#!/bin/bash

ip=$1
ipList="/etc/haproxy/tester.lst"
echo $1 >> $ipList
echo "#"$( date +%s ) >> $ipList
mv  /etc/haproxy/conf.d/015-horizon.cfg /etc/haproxy/conf.d/015-horizon.txt 2>/dev/null
mv  /etc/haproxy/conf.d/015-horizon-testing.txt /etc/haproxy/conf.d/015-horizon-testing.cfg 2>/dev/null
crm resource restart clone_p_haproxy
