#####################################################

MAKE = make
Enclave_Name = enclave
App_Name = app_demo
Enclave_Path = Enclave
App_Path = App

SGX_MODE ?= SIM

export ROOT=$(shell pwd)

all:
	@$(MAKE) -C $(Enclave_Path) SGX_MODE=$(SGX_MODE)
	@$(MAKE) -C $(App_Path)  SGX_MODE=$(SGX_MODE)
	@echo && echo DONE

clean:
	@$(MAKE) -C $(Enclave_Path) clean
	@$(MAKE) -C $(App_Path)  clean
	@rm -f .gdb_history peda-session*