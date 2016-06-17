#! /bin/bash
ip=$1
if [[ -n "$ip" ]]; then
	controllers=$(fuel node | grep ' controller' | grep '10.20.0.[0-9]*' -o)
	if [[ !(-s /etc/A-B-Testing/subprocesses/init.txt) ]]; then
		for machine in ${controllers}; do
			scp /etc/A-B-Testing/subprocesses/tester.lst root@$machine:/etc/haproxy/ 2>/dev/null
			scp /etc/A-B-Testing/subprocesses/conf.d/015-horizon-testing.txt root@$machine:/etc/haproxy/conf.d 2>/dev/null
			scp /etc/A-B-Testing/subprocesses/conf.d/175-testing.cfg root@$machine:/etc/haproxy/conf.d 2>/dev/null
		done
		echo "0 * * * * root /etc/A-B-Testing/subprocesses/stop_test.sh 2>/dev/null" >> /etc/crontab
		echo "yes" >> /etc/A-B-Testing/subprocesses/init.txt
	fi
	for machine in ${controllers}; do
		ssh root@$machine 'bash -s' < /etc/A-B-Testing/subprocesses/run_test.sh "$ip" 2>/dev/null
	done 
else
	echo "Please pass your IP as an argument" 
fi
