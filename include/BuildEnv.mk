CC = gcc
LD = gcc
AR = ar
MAKE = make
SSL = openssl

SGX_SDK ?= /opt/intel/sgxsdk
SGX_MODE ?= SIM
SGX_DEBUG ?= 1
SGX_ARCH ?= x64

INCLUDE_DIR = $(ROOT)/include

ifeq ($(SGX_ARCH), x64)
	SGX_COMMON_CFLAGS = -m64
	SGX_LIBRARY_PATH = $(SGX_SDK)/lib64
endif

ifeq ($(SGX_DEBUG), 1)
	SGX_COMMON_CFLAGS += -O0 -g
else
	SGX_COMMON_CFLAGS += -O2
endif

SGX_EDGER8R = sgx_edger8r
SGX_ENCLAVE_SIGNER = sgx_sign

Enclave_Name = enclave
App_Name = app_demo