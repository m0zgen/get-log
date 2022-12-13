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
-f - Path to remote file
-l - Servers list
"
    exit 1
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--skip) _SKIP=1; ;;
        -f|--file) _FILE=1 _FILE_DATA=$2; ;;
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
    _SERVERS_LIST=`cat $_LIST_DATA`
else
    _SERVERS_LIST=`cat $SCRIPT_PATH/servers.txt`
fi

if [[ -z "$_FILE" ]]; then
    echo "Set remote file path please. Exit."
    exit 1
else
    _DEST_FILE=$_FILE_DATA  
fi


# Functions variables
# ---------------------------------------------------\
function getFile() {
    echo "[✓] Get to: $1"

    if ! ssh $2 "test -e $1" 2> /dev/null; then
        echo "File $1 not exist"
    else

        local fileDir=$SCRIPT_PATH/collection
        local serverDir=$fileDir/$2

        if [[ ! -d "$fileDir" ]]; then
            mkdir -p $fileDir
        fi

        if [[ ! -d "$serverDir" ]]; then
            mkdir $serverDir
        fi

        echo "Copy $1 to $serverDir:"
        scp -r -o IdentitiesOnly=yes $2:$1 $serverDir/


    fi
}

function callFromTest() {

    ping -c1 -W1 -q $_server &>/dev/null
    status=$( echo $? )
    if [[ $status == 0 ]] ; then
         echo "[✓] Success: ${_server} available."
         getFile $_FILE_DATA $_server
    else
         echo "[✗] Fail: ${_server} not available."
    fi

}

function getServers() {

    for _server in ${_SERVERS_LIST}; do

        if [[ "$_SKIP" -eq "1" ]]; then
            getFile $_FILE_DATA $_server
        else
            callFromTest
        fi
        

    done
}

getServers
