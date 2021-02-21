# C/C++ Type Declarator grammar
[![Build Status](https://travis-ci.org/maximmenshikov/type-grammar.svg?branch=master)](https://travis-ci.org/maximmenshikov/type-grammar)

An implementation of type declarator grammar which can be used to interpret C/C++ types.
e.g.:

	enum std::`class _Mutex_base<__gnu_cxx::_S_mutex>`::(anonymous at /usr/bin/../lib/gcc/x86_64-linux-gnu/10/../../../../include/c++/10/bits/shared_ptr_base.h:112:7)

This doesn't mean this grammar is perfect. You should still make a visitor for the parser for it to be useful.

## License
MIT
