#! /bin/bash
####################################################################################################
# author: arnd (at) netzturbine (dot) de                                                           #
# version 0.1b                                                                                     #
# description: configuration of basic vars + some checks                                           #
# it is part of a collection of helper scripts I used to quick setup an android build environment  #
####################################################################################################

#define root dir
ABH_COMPILE_ROOT="${HOME}/android/";

export ABH_COMPILE_ROOT=${ABH_COMPILE_ROOT};

#include funtions needed by scripts
if [ -f functions.lib.sh ]
then
    source functions.lib.sh;
    echo -e "START: found functions library \nswitching to configured Logging";
    MSG="START: found functions library \n";
else
    echo -e "ERR: could not find functions library ...bailing out";
    exit 1;
fi

# configure logging
# set debugging (not yet implemented) 
# possible values are
# 0 - throw everything away (not recommended until you know what you are doing)
# 1 - show ERRs only
# 2 - show ERRs + WARNs
# 3 - show everything
# ABH_DEBUG_LEVEL="3";
# export DEBUGLEVEL=${ABH_DEBUG_LEVEL};

# possible values 'file' 'console' 'none'
ABH_LOG_FACILITY="console";
export LOGFACILITY=${ABH_LOG_FACILITY};

# define logdir
ABH_LOG_DIR="${ABH_COMPILE_ROOT}/bin/log/";
export LOGDIR=${ABH_LOG_DIR};

#define global logname
ABH_GLOBAL_LOGNAME="-abh.log";

#define local log name
ABH_LOG_FILE="main${ABH_GLOBAL_LOGNAME}";
export LOGFILE=${ABH_LOG_FILE};

#define default builddir - must not b changed if you followed the usual android tutorials
ABH_DEFAULT_BUILD_DIR="system";
export ABH_DEFAULT_BUILD_DIR=${ABH_DEFAULT_BUILD_DIR};

#define default directory to store sign keys (defaults to dir signingkeys)
ABH_DEFAULT_KEYSTORE="./signingkeys";

# define additional builddirs
# here you can define additional builddirs to b included
ABH_ADDITIONAL_BUILD_DIRS="system_X system_Y";
export ABH_ADDITIONAL_BUILD_DIRS=${ABH_ADDITIONAL_BUILD_DIRS};

if [[ ${LOGFACILITY} == "file" ]]
then
    #check if ${ABH_LOG_DIR} exists + is writeable
	checkForDir "LOGDIR" ${ABH_LOG_DIR};
fi

#test if ${ABH_COMPILE_ROOT} exists + is writeable
checkForDir "ABH_COMPILE_ROOT" ${ABH_COMPILE_ROOT};

if [[ ${ABH_ADDITIONAL_BUILD_DIRS} != "" ]]
then
	for DIR in ${ABH_ADDITIONAL_BUILD_DIRS}
	do
		checkForDir "ABH_ADDITIONAL_BUILD_DIR" ${DIR};
    done
fi

#log it
log "${MSG}" "INF";
log "Initialized Variables and logging" "INF";


