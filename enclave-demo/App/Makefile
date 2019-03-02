ROOT ?= ..
include $(ROOT)/include/BuildEnv.mk

###########################################

ifeq ($(SGX_MODE), SIM)
	Urts_Library_Name := sgx_urts_sim
else
	Urts_Library_Name := sgx_urts
endif

ifeq ($(SGX_MODE), SIM)
	App_Link_Flags += -lsgx_uae_service_sim
else
	App_Link_Flags += -lsgx_uae_service
endif

App_Include_Paths := -I$(SGX_SDK)/include -I$(INCLUDE_DIR)

App_C_Flags := $(SGX_COMMON_CFLAGS) -fPIC -Wno-attributes $(App_Include_Paths)

ifeq ($(SGX_DEBUG), 1)
        App_C_Flags += -DDEBUG -UNDEBUG
else
        App_C_Flags += -DNDEBUG -UDEBUG
endif

App_Link_Flags := $(SGX_COMMON_CFLAGS) -L$(SGX_LIBRARY_PATH) -l$(Urts_Library_Name) -lpthread

App_Name := app_demo
######### Add other .c files here
App_C_Files := $(App_Name).c $(Enclave_Name)_u.c sgx_error.c
#########
App_C_Objects := $(App_C_Files:.c=.o)
Enclave_EDL := $(INCLUDE_DIR)/enclave.edl
App := $(ROOT)/$(App_Name)

######## Start Compiling ########

.PHONY: clean path

$(App) : $(App_C_Objects)
	@echo "[LD] $< => $@"
	@$(LD) $^ -o $(App) $(App_Link_Flags)

app_demo.o: app_demo.c $(Enclave_Name)_u.h
	@echo "[CC] $< => $@"
	@$(CC) $(App_C_Flags) -c $< -o $@

%.o : %.c
	@echo "[CC] $< => $@"
	@$(CC) $(App_C_Flags) -c $< -o $@

$(Enclave_Name)_u.h:
	@echo "[GEN] $@ $(Enclave_Name)_u.c"
	@$(SGX_EDGER8R) --untrusted $(Enclave_EDL) --search-path $(INCLUDE_DIR) --search-path $(SGX_SDK)/include

$(Enclave_Name)_u.c:
	@echo "[GEN] $@ $(Enclave_Name)_u.h"
	@$(SGX_EDGER8R) --untrusted $(Enclave_EDL) --search-path $(INCLUDE_DIR) --search-path $(SGX_SDK)/include

clean:
	@echo [RM] $(App_Name)
	@rm -f *.o $(App) $(Enclave_Name)_u.*

path:
	echo | $(CC) $(App_C_Flags) -E -Wp,-v -