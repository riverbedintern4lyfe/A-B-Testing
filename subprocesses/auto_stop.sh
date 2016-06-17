# !/bin/bash

controllers=$(fuel node | grep ' controller' | grep '10.20.0.[0-9]*' -o)
	for machine in ${controllers}; do
		ssh root@$machine 'bash -s' < /etc/A-B-Testing/subprocesses/stopTest.sh 2>/dev/null
	done 
