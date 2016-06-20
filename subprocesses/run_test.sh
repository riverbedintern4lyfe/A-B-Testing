#!/bin/bash
# This file modifies HAProxy so that it is in testing mode

ip=$1
ipList="/etc/haproxy/tester.lst"

# add ip to ip list of testers with the time added
echo $1 >> $ipList
echo "#"$( date +%s ) >> $ipList

# set the configurations for HAProxy to testing mode and restart HAProxy
mv  /etc/haproxy/conf.d/015-horizon.cfg /etc/haproxy/conf.d/015-horizon.txt 2>/dev/null
mv  /etc/haproxy/conf.d/015-horizon-testing.txt /etc/haproxy/conf.d/015-horizon-testing.cfg 2>/dev/null
crm resource restart clone_p_haproxy
