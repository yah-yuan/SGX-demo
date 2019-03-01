ROOT ?= ..
include $(ROOT)/include/BuildEnv.mk

######## Enclave Settings ########

ifeq ($(SGX_MODE), SIM)
	Trts_Library_Name := sgx_trts_sim
	Service_Library_Name := sgx_tservice_sim
else
	Trts_Library_Name := sgx_trts
	Service_Library_Name := sgx_tservice
endif

Crypto_Library_Name := sgx_tcrypto
Enclave_Include_Paths := -I$(SGX_SDK)/include -I$(SGX_SDK)/include/tlibc -I$(INCLUDE_DIR)
Enclave_C_Flags := $(SGX_COMMON_CFLAGS) -nostdinc -fvisibility=hidden -fpie -ffunction-sections \
	-fdata-sections -fstack-protector-strong
Enclave_C_Flags += $(Enclave_Include_Paths) -nostdinc
Enclave_Link_Flags := $(SGX_COMMON_CFLAGS) -Wl,--no-undefined \
	-nostdlib -nodefaultlibs -nostartfiles -L$(SGX_LIBRARY_PATH) \
	-Wl,--whole-archive -l$(Trts_Library_Name) -Wl,--no-whole-archive \
	-Wl,--start-group -lsgx_tstdc -lsgx_tcxx -l$(Crypto_Library_Name) \
	-l$(Service_Library_Name) -Wl,--end-group \
	-Wl,-Bstatic -Wl,-Bsymbolic -Wl,--no-undefined \
	-Wl,-pie,-eenclave_entry -Wl,--export-dynamic  \
	-Wl,--defsym,__ImageBase=0 -Wl,--gc-sections

Enclave_Name ?= enclave

######### Add .c files here
Enclave_C_Files = $(Enclave_Name).c $(Enclave_Name)_t.c
#########
Enclave_C_Objects = $(Enclave_C_Files:.c=.o)
Enclave_Object := $(Enclave_Name).so
Signed_Enclave_Object := $(ROOT)/$(Enclave_Name).signed.so
Enclave_Config_File := $(Enclave_Name).config.xml
Enclave_Key_File = $(Enclave_Name).pem
Enclave_EDL = $(INCLUDE_DIR)/enclave.edl

######## Start Compiling ########
.PHONY: clean

$(Signed_Enclave_Object): $(Enclave_Object) $(Enclave_Key_File)
	@echo "[SIGN] =>  $@"
	@$(SGX_ENCLAVE_SIGNER) sign -key $(Enclave_Key_File) -enclave $(Enclave_Object) -out $@ -config $(Enclave_Config_File)

$(Enclave_Key_File):
	@echo "[GEN] => $@"
	@$(SSL) genrsa -out $@ -3 3072

%.o: %.c
	@echo "[CC]  $< => $@"
	@$(CC) $(Enclave_C_Flags) -c $< -o $@

$(Enclave_Name).o: $(Enclave_Name).c $(Enclave_Name)_t.h
	@echo "[CC] $< => $@"
	@$(CC) $(Enclave_C_Flags) -c $< -o $@ 

$(Enclave_Name)_t.c: $(Enclave_EDL)
	@echo "[GEN]  =>  $@"
	@$(SGX_EDGER8R) --trusted $(Enclave_EDL) --search-path $(INCLUDE_DIR) --search-path $(SGX_SDK)/include

$(Enclave_Name)_t.h: $(Enclave_EDL)
	@echo "[GEN]  =>  $@"
	@$(SGX_EDGER8R) --trusted $(Enclave_EDL) --search-path $(INCLUDE_DIR) --search-path $(SGX_SDK)/include

$(Enclave_Object): $(Enclave_C_Objects)
	@echo "[LD] $< =>  $@"
	@$(LD) $^ -o $@ $(Enclave_Link_Flags)

clean:
	@echo [RM] $(Enclave_Name)
	@rm -f enclave_t.* *.o $(Signed_Enclave_Object) $(Enclave_Object)