#!/bin/bash
# This file removes ip adresses from the tester.lst. The causes those ips to return to normal traffic
# This file also turns off testing mode if necessary.

ip_list="/etc/haproxy/tester.lst"
remove_ip=$1
declare -i line_number
line_number=1

# remove user input ip and time
if [[ -n $remove_ip ]]; then
	sed -i -e "/$remove_ip/{N; d;}" $ip_list
fi

# search for ips that have expired and remove them
while read line; do	
	if [[ $(($line_number%2)) == 0 ]]; then
		time=${line:1}
		if [[ $(($(($( date +%s ) - $time)))) -gt 180 ]]; then
			sed -i "$(($line_number-1)),$line_number d" $ip_list
			line_number=$(($line_number-2))
		fi
	fi
	line_number+=1
done <$ip_list

# if there are no more testers, turn off testing mode
if [[ !(-s $ip_list) ]]; then
	mv  /etc/haproxy/conf.d/015-horizon.txt /etc/haproxy/conf.d/015-horizon.cfg 2>/dev/null
	mv  /etc/haproxy/conf.d/015-horizon-testing.cfg /etc/haproxy/conf.d/015-horizon-testing.txt 2>/dev/null
fi

# restart HAProxy
crm resource restart clone_p_haproxy
	
