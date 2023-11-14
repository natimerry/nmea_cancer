#include "bindings.h"
    
    const struct gps_data *parse_gpgga_mip(const char *buf){
        gps_data *gps = (gps_data*)parse_gpgga(buf);
        
        if (gps->alt==0x0)
            gps->alt="";

        if (gps->lat==0x0)
            gps->lat="";

        if (gps->longi==0x0)
            gps->longi="";

        if (gps->gtime==0x0)
            gps->gtime="";

        if (gps->speed==0x0)
            gps->head="";

        if (gps->qual==0x0)
            gps->qual="";

        if (gps->speed==0x0)
            gps->speed="";

        return gps;
    }