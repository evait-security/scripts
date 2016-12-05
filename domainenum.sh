#!/bin/bash

echo "-----------------------------------------------------------------------------------------"
echo "[*] evait security GmbH - Quick domain enumeration script v1.1"
echo "-----------------------------------------------------------------------------------------"
echo "[*] Usage with null session: bash domainenum.sh -t {TARGET IP}"
echo "[*] Usage with credentials: bash domainenum.sh -u {USERNAME} -p {PASSWORD} -t {TARGET IP}"
echo "-----------------------------------------------------------------------------------------"
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -u|--user)
    VAR_USER="$2"
    shift # past argument
    ;;
    -p|--pass)
    VAR_PASS="$2"
    shift # past argument
    ;;
    -t|--target)
    VAR_TARGET="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

VAR_OPTIONS=""
if [ -z "$VAR_TARGET" ]; then           #target is empty
    echo "$(tput setaf 1)[-] No target given. Use '-t' option to specify a target."
    exit
else
    if [ -z "$VAR_USER" ]; then         #user is empty
        VAR_OPTIONS="-U \"\" -N" 
    else
        if [ -z "$VAR_PASS" ]; then     #user is set but pass is empty
            VAR_OPTIONS="-U \"$VAR_USER\" -N"
        else                            #user and pass is set
            VAR_OPTIONS="-U \"$VAR_USER"
            VAR_OPTIONS+="%$VAR_PASS"
            VAR_OPTIONS+="\"" 
        fi
    fi

    VAR_COMMAND="rpcclient $VAR_OPTIONS -c enumdomusers $VAR_TARGET | cut -f 2 -d [ | cut -f 1 -d ]"
    echo "$(tput setaf 2)[+] Enumerate all domain users ..."
    echo -n "$(tput setaf 7)"
    echo "[*] execute: $VAR_COMMAND"
    eval $VAR_COMMAND > /tmp/dom_users.txt

    VAR_COMMAND="rpcclient $VAR_OPTIONS -c enumdomgroups $VAR_TARGET | cut -f 2 -d [ | cut -f 1 -d ]"
    echo "$(tput setaf 2)[+] Enumerate all domain groups ..."
    echo -n "$(tput setaf 7)"
    echo "[*] execute: $VAR_COMMAND"
    eval $VAR_COMMAND > /tmp/dom_groups.txt
  
    echo "$(tput setaf 2)[+] Enumerate all domain admins ..."
    echo -n "$(tput setaf 7)"
    VAR_COMMAND="rpcclient $VAR_OPTIONS -c 'querygroupmem 0x200' $VAR_TARGET | cut -f 2 -d [ | cut -f 1 -d ]"
    echo "[*] execute loop: $VAR_COMMAND"
    
    cat /dev/null > /tmp/dom_admins.txt
    for usr in $( eval $VAR_COMMAND ); do
        VAR_COMMAND="rpcclient $VAR_OPTIONS -c 'queryuser $usr' $VAR_TARGET | grep 'User Name' | cut -f 2 -d ':' | sed -r 's/\s*(.*?)\s*$/\1/'"
        eval $VAR_COMMAND >> /tmp/dom_admins.txt
    done
    
    echo -n "$(tput setaf 7)"
    echo "----------------------------------------------------------"
    echo "[*] Result of enumeration"
    echo "----------------------------------------------------------"
    echo "$(tput setaf 2)[+] Domain users in /tmp/dom_users.txt"
    echo -n "$(tput setaf 7)"
    cat /tmp/dom_users.txt
    echo ""
    echo "$(tput setaf 2)[+] Domain users in /tmp/dom_groups.txt"
    echo -n "$(tput setaf 7)"
    cat /tmp/dom_groups.txt
    echo ""
    echo "$(tput setaf 2)[+] Domain users in /tmp/dom_admins.txt"
    echo -n "$(tput setaf 7)"
    cat /tmp/dom_admins.txt
fi
