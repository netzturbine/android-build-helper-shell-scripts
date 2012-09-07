#!/bin/bash
####################################################################################################
# author: arnd (at) netzturbine (dot) de                                                           #
# version 0.1b                                                                                     #
# description: script creates keys to sign packages                                                #
# it is part of a collection of helper scripts I used to quick setup an android build environment  #
####################################################################################################

#include config + functions needed by script
if [ -f config.inc.sh ]
then
    source config.inc.sh;
    MSG="$MSG found config";
else
    echo -e "ERR: could not find config ...bailing out";
    exit 1;
fi

KEYDIRECTORY="${2}";
KEYNAME="${1}-";

if [[ ${KEYDIRECTORY} != "" ]]
then
    checkForDir "writable KEYDIRECTORY" ${KEYDIRECTORY};
else
    checkForDir "writable ABH_DEFAULT_KEYSTORE" ${ABH_DEFAULT_KEYSTORE};
    ${KEYDIRECTORY} = ${ABH_DEFAULT_KEYSTORE};
fi

cd ${KEYDIRECTORY};


if [ ${1} -le 0 ]
then
    log "you must define a KEYNAME as 1st parameter - EXIT" "WARN";
    exit 1;
fi



openssl genrsa -out ${KEYNAME}key.pem 1024
openssl req -new -key ${KEYNAME}key.pem -out request.pem
openssl x509 -req -days 9999 -in ${KEYNAME}request.pem -signkey ${KEYNAME}key.pem -out ${KEYNAME}certificate.pem
openssl pkcs8 -topk8 -outform DER -in ${KEYNAME}key.pem -inform PEM -out ${KEYNAME}key.pk8 -nocrypt