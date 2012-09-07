#!/bin/bash
####################################################################################################
# SRC: https://github.com/netzturbine/android-build-helper-shell-scripts.git                       #
# AUTHOR: arnd (at) netzturbine (dot) de                                                           #
# VERSION: 0.1b                                                                                    #
# DESCRIPTION: script signs  packages w/ keys from ABH_DEFAULT_KEYSTORE or given KEYSTORE dir      #
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

pushd ${ABH_DEFAULT_TOOLSTORE};

if [ ! -f ${ABH_DEFAULT_TOOLSTORE}/bin/signapk ]
then
	F__checkForDir "ABH_DEFAULT_TOOLSTORE download" "${ABH_DEFAULT_TOOLSTORE}/downloads" "true";
	wget https://signapk.googlecode.com/files/signapk-0.3.1.tar.bz2 "${ABH_DEFAULT_TOOLSTORE}/downloads/"
	tar xvjf ${ABH_DEFAULT_TOOLSTORE}/downloads/signapk-0.3.1.tar.bz2 "${ABH_DEFAULT_TOOLSTORE}/";
fi

# cutting filename in pieces
FILENAME=$(echo ${1} | awk -F. '{print $1}');
FILEPREFIX=$(echo ${1} | awk -F. '{print $1}');

# get existing certinfo
#signapk certinfo ${FILENAME}.${FILEPREFIX};

#signing package
echo "signapk -k sign ${FILENAME}.${FILEPREFIX} ${FILENAME}_signed.${FILEPREFIX};"

# get modified certinfo
#signapk certinfo ${FILENAME}_signed.${FILEPREFIX};
