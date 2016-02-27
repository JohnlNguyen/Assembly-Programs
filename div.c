#include <stdio.h>
#include <stdlib.h>

int main ( int argc, char *argv[] ){
    if(argc < 1) exit(1);
    unsigned int dividend = 0;
    unsigned int divisor = 0;
    unsigned int quotient = 0;
    unsigned int counter = 1;
    unsigned long mask = 1 << 31;
    sscanf(argv[1], "%u", &dividend);
    sscanf(argv[2], "%u", &divisor);
    int copy_div = divisor;
    int copy_dend = dividend;
    while (((divisor & mask) == 0) && ((divisor << 1) <= dividend)) {
        divisor <<= 1;
        counter <<= 1;
    }

    while(counter != 0){
        if(dividend >= divisor){
            dividend -= divisor;
            quotient |= counter;
        }
        counter >>= 1;
        divisor >>= 1;
    }

    int remainder = copy_dend - (quotient*copy_div);
    printf("%u / %u = %u R %u\n" , copy_dend, copy_div, quotient, remainder);
    return 0;
}
