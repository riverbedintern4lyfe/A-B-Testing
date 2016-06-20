#! /bin/bash
# This file is for launching a user as a tester. It will also config the proper files if they have not been created yet.

ip=$1
# make sure user passed an argument
if [[ -n "$ip" ]]; then
	controllers=$(fuel node | grep ' controller' | grep '10.20.0.[0-9]*' -o)

	# only execute this section once
	if [[ !(-s /etc/A-B-Testing/subprocesses/init.txt) ]]; then
	
		# copy over the needed files to the controllers, 
		# set a cron job to removed expired ips from the testing list and make the system as initalized
		for machine in ${controllers}; do
			scp /etc/A-B-Testing/subprocesses/tester.lst root@$machine:/etc/haproxy/ 2>/dev/null
			scp /etc/A-B-Testing/subprocesses/conf.d/015-horizon-testing.txt root@$machine:/etc/haproxy/conf.d 2>/dev/null
			scp /etc/A-B-Testing/subprocesses/conf.d/not_tester.txt root@$machine:/etc/haproxy/conf.d 2>/dev/null
			scp /etc/A-B-Testing/subprocesses/conf.d/tester.txt root@$machine:/etc/haproxy/conf.d 2>/dev/null
			ssh root@$machine 'bash -s' < /etc/A-B-Testing/subprocesses/set_config.sh 2>/dev/null
		done
		echo "0 * * * * root /etc/A-B-Testing/subprocesses/stop_test.sh 2>/dev/null" >> /etc/crontab
		echo "yes" >> /etc/A-B-Testing/subprocesses/init.txt
	fi

	# use ssh to acess the controller machines and launch run_test.sh
	for machine in ${controllers}; do
		ssh root@$machine 'bash -s' < /etc/A-B-Testing/subprocesses/run_test.sh "$ip" 2>/dev/null
	done 

# error if no argument was passed
else
	echo "Please pass your IP as an argument" 
fi
