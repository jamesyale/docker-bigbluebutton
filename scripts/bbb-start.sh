#!/bin/bash
# Little helper start script for BigBlueButton in a docker container.
# Author: Juan Luis Baptiste <juan.baptiste@gmail.com>

function get_ip (){
    curl ip.appspot.com
}

IP=`get_ip`

echo -e "Starting BigBlueButton services...\n"
service redis-server-2.2.4 start
service bbb-openoffice-headless start
echo -e "Updating BigBlueButton IP address configuration...\n"
bbb-conf --setip $IP
echo -e "Checking BigBlueButton configuration...\n"
bbb-conf --check

echo -e "*******************************************"
echo -e "Use this IP address to locally access your \nBigBlueButton container: \n\n$IP\n"
echo -e "*******************************************\n"

#Ugly hack: Infinite loop to maintain the container running
#while true;do sleep 100000;done

# dump logs to stdout for docker log viewing
# ideally each service should be in a seperate container
tail -f -n0 /var/log/bigbluebutton/*
