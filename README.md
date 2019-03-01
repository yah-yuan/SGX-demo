My SGX demo, with adapted Makefile and directory tree. Seems to be more readable.

Just learning of SGX programming structure

other C-based sgx applications of mine should base on this framwork

Requirements:

* gcc version > 4.9
* x86_64

Notes:

* Can not be debuged using gdb. SGXSDK provides its own debug tool named sgx-gdb. Technically it is an advanced and adapted debug tool based on GNU gdb, but seems it isn't compatibal with vscode(guese not neither with other ides). However, it is known that Visual Studio works fine with it.

* The Enclave HAS to be signed using sgx_sign, though error code 0x2009 will be thrown out.

* This demo will touch a token file to your home directory, witch devotes to accelerate the Enclave loading speed the next time you tend to load it. A way to verify, that's it.