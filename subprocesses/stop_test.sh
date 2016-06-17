# !/bin/bash

ip=$1
controllers=$(fuel node | grep ' controller' | grep '10.20.0.[0-9]*' -o)
	for machine in ${controllers}; do
		ssh root@$machine 'bash -s' < /etc/A-B-Testing/subprocesses/stop_test.sh "$ip" 2>/dev/null
	done 
