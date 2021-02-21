#!/bin/bash
test="$1"
top_folder="$(pwd)"
parslr_git="https://github.com/maximmenshikov/parslr.git"
antlr_file="antlr-4.9.1-complete.jar"
antlr_url="https://www.antlr.org/download/antlr-4.9.1-complete.jar"
test_path="${top_folder}/test"

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
		exit 1
	fi
	if [ ! -f "${antlr_file}" ] ; then
		wget "${antlr_url}"
	fi
	if [ ! -f "${antlr_file}" ] ; then
		exit 2
	fi

	antlr_path="$(pwd)/${antlr_file}"
	pushd parslr
		tests=
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
			echo "====="
			echo "All failed tests:"
			for fail in ${failed} ; do
				echo " - ${fail}"
			done
		fi
	popd
popd