#! /bin/bash
####################################################################################################
# SRC: https://github.com/netzturbine/android-build-helper-shell-scripts.git                       #
# AUTHOR: arnd (at) netzturbine (dot) de                                                           #
# VERSION: 0.1b                                                                                    #
# DESCRIPTION: configuration of basic vars + some checks                                           #
# it is part of a collection of helper scripts I used to quick setup an android build environment  #
#                                                                                                  #
# all variables starting w/ ABH_ are defined in this file                                          #
# all funtions starting w/ F__ are defined in functions.lib.sh                                     #
#                                                                                                  #
# for further Information see README.txt/README.md                                                 #
####################################################################################################

#define root dir
ABH_COMPILE_ROOT="${HOME}/android";
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

#define this apps root dir and set it as ABH_BIN_ROOT
F__getBasedir;
export ABH_BIN_ROOT=${BASEDIR};

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
ABH_LOG_DIR="${ABH_BIN_ROOT}/log";

#define global logname
ABH_GLOBAL_LOGNAME="-abh.log";

#define local log name
ABH_LOG_FILE="${ABH_LOG_DIR}/main${ABH_GLOBAL_LOGNAME}";
export LOGFILE=${ABH_LOG_FILE};

#define default directory to store sign keys (defaults to dir signingkeys)
ABH_DEFAULT_KEYSTORE="${ABH_BIN_ROOT}/signingkeys";
export ABH_DEFAULT_KEYSTORE=${ABH_DEFAULT_KEYSTORE};

#define default directory to store sign keys (defaults to dir signingkeys)
ABH_DEFAULT_TOOLSTORE="${ABH_BIN_ROOT}/tools";
export ABH_DEFAULT_TOOLSTORE=${ABH_DEFAULT_TOOLSTORE};

#define default builddir - must not b changed if you followed the usual android tutorials
ABH_DEFAULT_BUILD_DIR="system";

# define additional builddirs
# here you can define additional builddirs to b included
# ABH_ADDITIONAL_BUILD_DIRS="system_X system_Y";

if [[ ${ABH_LOG_FACILITY} == "file" ]]
then
    #check if ${ABH_LOG_DIR} exists + is writeable
	F__checkForDir "ABH_LOG_DIR" ${ABH_LOG_DIR};
fi

#export build dirs
export ABH_BUILD_DIR_0=${ABH_DEFAULT_BUILD_DIR};

declare -i count=1;

if [[ ${ABH_ADDITIONAL_BUILD_DIRS} != "" ]]
then
	for DIR in ${ABH_ADDITIONAL_BUILD_DIRS}
	do
	    export ABH_BUILD_DIR_${count}=${DIR};
   		count=$((count+1)); 
		F__checkForDir "ABH_ADDITIONAL_BUILD_DIR: ABH_BUILD_DIR_${count}" ${DIR};
    done
fi

#test if ${ABH_COMPILE_ROOT} exists + is writeable
F__checkForDir "ABH_COMPILE_ROOT" ${ABH_COMPILE_ROOT};

#test if local config exists + include it
if [ -f config.inc.local.sh ]
then
    source config.inc.local.sh;
    F__log "found local config: config.inc.local.sh ... using it \n" "INF";
else
    F__log "could not find local config: config.inc.local.sh ... see readme how to use it" "WARN";
fi

#log 
F__log "${MSG}" "INF";
F__log "Initialized Variables and logging" "INF";


