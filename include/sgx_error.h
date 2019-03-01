#include <unistd.h>
#include <stdio.h>
#include <sgx_urts.h>

typedef struct _sgx_errlist_t;
void print_error_message(sgx_status_t ret);