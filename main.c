#include "bindings.h"
#include "stdio.h"
int main(){
    // char x[1024] ="lkjskdf";
    gps_data *gps = parse_gpgga("$GPGGA,115739.00,4158.8441367,N,09147.4416929,W,4,13,0.9,255.747,M,-32.00,M,01,0000*6E");
    // printf("%s\n",gps->lat);
    print_str(gps);
}