#!/bin/bash

#changing mac address to random
#Iteratre through interfaces, shutting down and changing MAC and Name
for interf in $(ip link show | grep -oE 'eth[0-9]+')
do
	ifconfig $interf down
	randm=$( shuf -i17-255 -n1)
	printf -v result1 "%x" "$randm"
	randm=$(shuf -i17-255 -n1)
	printf -v result2 "%x" "$randm"
	macchanger -m 00:12:47:AF:$result1:$result2 $interf
	ifconfig $interf up
done
echo " "
for interf in $(ip link show | grep -oE 'wlan[0-9]+')
do
	ifconfig $interf down
	randm=$( shuf -i17-255 -n1)
	printf -v result1 "%x" "$randm"
	randm=$( shuf -i17-255 -n1)
	printf -v result2 "%x" "$randm"
	macchanger -m 00:12:47:2D:$result1:$result2 $interf
	ifconfig $interf up
done


#changing hostname to random word from dictionary

random=$(shuf -i18950708-4277992114 -n1)
printf -v hname "%x" "$random"

printf "%s\nChanging Hostname…\n"
OLDHOST=$(hostname)
hostnm="android-532ef9e7${random}"
hostname $hostnm
if [ $? == 0 ]; then
printf "%sPrevius Hostname: $OLDHOST \n"
printf "%sRandom Hostname: $hostnm \n"
/etc/init.d/hostname.sh start
else
printf "%sScript encounter an error, sorry…\n"
exit 1
fi

#END
