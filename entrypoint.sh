#!/bin/bash
if [ "WAIT_FOR" == "0" ];
then nginx -g "daemon off;";
else /wait-for.sh WAIT_FOR -t TIMEOUT -- nginx -g "daemon off;";
fi