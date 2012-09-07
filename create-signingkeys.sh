#!/bin/bash
####################################################################################################
# SRC: https://github.com/netzturbine/android-build-helper-shell-scripts.git                       #
# AUTHOR: arnd (at) netzturbine (dot) de                                                           #
# VERSION: 0.1b                                                                                    #
# DESCRIPTION: script creates keys to sign packages                                                #
# it is part of a collection of helper scripts I used to quick setup an android build environment  #
#                                                                                                  #
# all variables starting w/ ABH_ are defined in config.inc.shell                                   #
# all funtions starting w/ F__ are defined in functions.lib.sh                                     #
#                                                                                                  #
# for further Information see README.txt/README.md                                                 #
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

F__getBasedir();

KEYSTORE="${3}";
PASSWD="${2}";
KEYNAME="${1}";

if [[ ${KEYSTORE} != "" ]]
then
    F__checkForDir "writable KEYSTORE" ${KEYSTORE};
else
    F__checkForDir "writable ABH_DEFAULT_KEYSTORE" ${ABH_DEFAULT_KEYSTORE};
    ${KEYSTORE} = ${ABH_DEFAULT_KEYSTORE};
fi

if [[ ${PASSWD} == "" ]]
then
    if [[ ${ABH_KEY_DEFAULT_PWD} != "" ]]
    then
    	PASSWD="${ABH_KEY_DEFAULT_PWD}";
    else
    	F__log "you must define a PASSWD as 2nd parameter or define ABH_KEY_DEFAULT_PWD in  - EXIT" "WARN";
    	exit 1;
    fi
fi

if [[ ${KEYNAME} == "" ]]
then
    if [[ ${ABH_KEY_DEFAULT} != "" ]]
    then
    	KEYNAME="${ABH_KEY_DEFAULT}";
    else
    	F__log "you must define a KEYNAME as 1st parameter or define ABH_KEY_DEFAULT in  - EXIT" "WARN";
    	exit 1;
    fi
fi

#finally generate keys
function genSimpleKeys(){
	openssl genrsa -out ${KEYSTORE}/${KEYNAME}.key.pem 1024
	openssl req -new -key ${KEYSTORE}/${KEYNAME}.key.pem -out request.pem
	openssl x509 -req -days 9999 -in ${KEYSTORE}/${KEYNAME}.request.pem -signkey ${KEYSTORE}/${KEYNAME}.key.pem -out ${KEYSTORE}/${KEYNAME}.certificate.pem
	openssl pkcs8 -topk8 -outform DER -in ${KEYSTORE}/${KEYNAME}.key.pem -inform PEM -out ${KEYSTORE}/${KEYNAME}.key.pk8 -nocrypt;
	F__log "created keys in ${KEYSTORE}" "INF";
}

function genKeystore(){

keytool -genkeypair -keystore ${KEYSTORE}/${KEYNAME}.keystore -storepass ${PASSWD} -keyalg RSA \
  -validity $((25 * 365)) -alias ${KEYNAME} -keysize 2048 \
  -dname "CN=${ABH_KEYS_CN}, O=${ABH_KEYS_O}, L=${ABH_KEYS_L}, ST=${ABH_KEYS_ST}, C=${ABH_KEYS_C}"; 
  
   F__log "created keystore ${KEYSTORE}/${KEYNAME}.keystore" "INF";
  }