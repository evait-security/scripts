#!/bin/bash

if [ $# -gt 0 ] 
	then
		cat $1 | grep jtr | cut -f 3 > /tmp/tmp.txt
		rm -f /tmp/hashcat.txt
		perl scripts/convert_netNTLM_to_hashcat.pl /tmp/tmp.txt /tmp/hashcat.txt
		cat /tmp/hashcat.txt | sort -u
	else
		echo "[*] Usage: bash convert_hostapd_hashcat.sh {hostapd-logfile}"
fi
