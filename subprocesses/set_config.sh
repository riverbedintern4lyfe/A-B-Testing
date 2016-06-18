#!/bin/bash

delcare -i counter
counter=0
grep '192.168.0' /etc/haproxy/conf.d/015-horizon.cfg | while read -r line ; do
	if [[ $((counter)) -gt 1 ]]; then
		echo "  $line" >> /etc/haproxy/conf.d/not_tester.txt
	else
		echo "  $line" >> /etc/haproxy/conf.d/tester.txt
	fi
	counter+=1
done 
cat /etc/haproxy/conf.d/not_tester.txt >> /etc/haproxy/conf.d/175-testing.cfg
cat /etc/haproxy/conf.d/tester.txt >> /etc/haproxy/conf.d/175-testing.cfg
