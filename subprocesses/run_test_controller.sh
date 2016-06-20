#!/bin/bash
# This file modifies HAProxy so that it is in testing mode

ipList="/etc/haproxy/tester.lst"

# set the configurations for HAProxy to testing mode and restart HAProxy
mv  /etc/haproxy/conf.d/015-horizon.cfg /etc/haproxy/conf.d/015-horizon.txt 2>/dev/null
mv  /etc/haproxy/conf.d/015-horizon-testing.txt /etc/haproxy/conf.d/015-horizon-testing.cfg 2>/dev/null

#if an ip of a controller was passed, then a new testing backend will be created
if [[ -n "$2" ]]; then
	rm /etc/haproxy/conf.d/175-testing.cfg 2>/dev/null
	tester_server=$2

	#add the user inputed tester server to the tester backend
	grep "$tester_server" /etc/haproxy/conf.d/015-horizon.txt | sed -e 's/^/  /' >> /etc/haproxy/conf.d/tester.txt

	# find remaining controllers and add them to the not_tester backends
	grep '192.168.0' /etc/haproxy/conf.d/015-horizon.txt | grep -v "$tester_server" | while read -r line ; do
		echo "  $line" >> /etc/haproxy/conf.d/not_tester.txt
	done 

	# create the testing configuration file
	cat /etc/haproxy/conf.d/not_tester.txt >> /etc/haproxy/conf.d/175-testing.cfg
	cat /etc/haproxy/conf.d/tester.txt >> /etc/haproxy/conf.d/175-testing.cfg
fi

# add ip to ip list of testers with the time added
echo $1 >> $ipList
echo "#"$( date +%s ) >> $ipList

crm resource restart clone_p_haproxy

