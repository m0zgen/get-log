#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Simple collect dest logs to local

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Args & Helps
# ---------------------------------------------------\
# Help information
usage() {
    echo -e "Params:
-f - Path to remote log file
-l - Servers list
"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--file) _FILE=1; ;;
        -l|--list) _LIST=1 _LIST_DATA=$2; shift ;;
        -h|--help) usage ;; 
        *) _DEFAULT=1 ;;
    esac
    shift
done

# Initial variables
# ---------------------------------------------------\

# Options
if [[ "$_LIST" -eq "1" ]]; then
    _SERVERS_LIST=` cat $_LIST_DATA`
else
    _SERVERS_LIST=`cat $SCRIPT_PATH/servers.txt`
fi


# Functions variables
# ---------------------------------------------------\

function getServers() {
    for _server in ${_SERVERS_LIST}; do
        
        ping -c1 -W1 -q $_server &>/dev/null
        status=$( echo $? )
        if [[ $status == 0 ]] ; then
             echo "[✓] Success: ${_server} available"
        else
             echo "[✗] Fail: ${_server} not available. Exit. Bye."
             exit 1
        fi

    done
}

getServers
