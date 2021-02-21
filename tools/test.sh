#!/bin/bash
function fail()
{
	echo $@ >&2
	exit 1
}

junit_xml=
if [ "$1" == "junit" ] ; then
	junit_xml=$2
	junit_xml=$(realpath $junit_xml 2> /dev/null)
	if [ "${junit_xml}" == "" ] ; then
		fail "Invalid JUnit output path: '${junit_xml}'"
	fi
	shift 2
fi

test="$1"
top_folder="$(pwd)"
parslr_git="https://github.com/maximmenshikov/parslr.git"
antlr_file="antlr-4.9.1-complete.jar"
antlr_url="https://www.antlr.org/download/antlr-4.9.1-complete.jar"
test_path="${top_folder}/test"

function run_tests()
{
	local grammar="$1"
	local antlr_path="$2"
	local input="$3"
	local output="$4"

	rm -rf "$(pwd)/tmp"
	python3 -m parslr -g "${grammar}" \
					  -a "${antlr_path}" \
					  -r "entire_input" \
					  -i "${input}" \
					  -o "${output}"
	result=$?
	return "${result}"
}

function run_test()
{
	local grammar="$1"
	local antlr_path="$2"
	local input="$3"

	rm -rf "$(pwd)/tmp"
	python3 -m parslr -g "${grammar}" \
					  -a "${antlr_path}" \
					  -r "entire_input" \
					  -i "${input}"
	result=$?
	if [ "$result" == "0" ] ; then
		echo "Test $(basename ${input}) PASSED"
	else
		echo "Test $(basename ${input}) FAILED"
	fi
	return "${result}"
}

mkdir -p build
pushd build
	if [ ! -d parslr ] ; then
		git clone "${parslr_git}"
	fi
	if [ ! -d parslr ] ; then
		fail "Failed to download parslr"
	fi
	if [ ! -f "${antlr_file}" ] ; then
		wget "${antlr_url}"
	fi
	if [ ! -f "${antlr_file}" ] ; then
		fail "Failed to download antlr distribution"
	fi

	antlr_path="$(pwd)/${antlr_file}"
	pushd parslr
		tests=
		if [ -n "${junit_xml}" ] ; then
			# JUnit results (less data in stderr)
			if [ -n "${test}" ] ; then
				fail "There should be no particular test selected in JUnit mode"
			fi
			if [ -n "${test}" ] ; then
				tests="${test_path}/${test}.txt"
			else
				tests="${test_path}"
			fi

			run_tests "${top_folder}/Type.g4" \
					  "${antlr_path}" \
					  "${tests}" \
					  "${junit_xml}"
			failed=$?
			if [ "$failed" != "0" ] ; then
				echo "Total failed tests: ${failed}" >&2
				exit $failed
			fi
		else
			# One-by-one execution (information about particular failed tests is
			# in stderr)
			if [ -n "${test}" ] ; then
				tests=$(find ${test_path}/${test}.txt)
			else
				tests=$(find ${test_path}/*.txt)
			fi
			failed=
			for file in ${tests} ; do
				run_test "${top_folder}/Type.g4" \
						 "${antlr_path}" \
						 "${file}"
				if [ "$?" != "0" ] ; then
					failed="${failed} $(basename ${file})"
				fi
			done

			if [ "${failed}" != "" ] ; then
				echo "=====" >&2
				echo "All failed tests:" >&2
				for fail in ${failed} ; do
					echo " - ${fail}" >&2
				done
				exit 1
			fi
		fi
	popd
popd