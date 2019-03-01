#include <stdio.h>

char * secret = "I am a secret";
char buff[20];

void e_call_print_secret() {
    snprintf(buff,20 ,"%s", secret);
}