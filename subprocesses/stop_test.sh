#!/bin/bash

ip_list="/etc/haproxy/tester.lst"
remove_ip=$1
declare -i line_number
line_number=1

if [[ -n $remove_ip ]]; then
	sed -i -e "/$remove_ip/{N; d;}" $ip_list
fi
while read line; do	
	if [[ $(($line_number%2)) == 0 ]]; then
		time=${line:1}
		temp=$(($(($( date +%s ) - $time))))
		if [[ $(($(($( date +%s ) - $time)))) -gt 3600 ]]; then
			echo $temp
			sed -i "$(($line_number-1)),$line_number d" $ip_list
			line_number=$(($line_number-2))
		fi
	fi
	line_number+=1
done <$ip_list

if [[ !(-s $ip_list) ]]; then
	mv  /etc/haproxy/conf.d/015-horizon.txt /etc/haproxy/conf.d/015-horizon.cfg 2>/dev/null
	mv  /etc/haproxy/conf.d/015-horizon-testing.cfg /etc/haproxy/conf.d/015-horizon-testing.txt 2>/dev/null
fi
crm resource restart clone_p_haproxy
	
