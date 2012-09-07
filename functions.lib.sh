#! /bin/bash
####################################################################################################
# SRC: https://github.com/netzturbine/android-build-helper-shell-scripts.git                       #
# AUTHOR: arnd (at) netzturbine (dot) de                                                           #
# VERSION: 0.1b                                                                                    #
# DESCRIPTION:                                                                                     #
# library which contains some shell functions/settings used in this script bundle                  #
# sourced by config.inc.sh by default                                                              #
# all funtions starting w/ F__ are defined in this file                                            #
#                                                                                                  #
# for further Information see README.txt/README.md                                                 #
####################################################################################################

# define colours
export BLACK="\033[0;30m"
export BLUE="\033[0;34m"
export GREEN="\033[0;32m"
export CYAN="\033[0;36m"
export RED="\033[0;31m"
export PURPLE="\033[0;35m"
export BROWN="\033[0;33m"
export LIGHTGRAY="\033[0;37m"
export DARKGRAY="\033[1;30m"
export LIGHTBLUE="\033[1;34m"
export LIGHTGREEN="\033[1;32m"
export LIGHTCYAN="\033[1;36m"
export LIGHTRED="\033[1;31m"
export LIGHTPURPLE="\033[1;35m"
export YELLOW="\033[1;33m"
export WHITE="\033[1;37m"
export NC="\033[1;0m"              # No Color


function F__getBasedir()
{
	BASEDIR=$(cd $(dirname "$0"); pwd);
	
	case "${BASEDIR}" in 
        [./]*)
            local ABSPATH="$(cd ${1%/*}; pwd)/${1##*/}"
            echo "${ABSPATH/\/\///}"
        ;;
        *)
            echo "${PWD}/${BASEDIR}";
        ;;
    esac
    
    export BASEDIR=${BASEDIR};

}

function F__resetVars(){
	PREFIX=${1};
	F__log "unsetting ${PREFIX} vars" "INF";
	PARAMS=`env | grep ${PREFIX}`;
	for PARAM in ${PARAMS}
	do
	    UNSET=$(echo ${PARAM} | awk -F= '{print $1}' );
	    unset ${UNSET}
    	#F__log "unset ${UNSET}" "INF";
	done
}

###################################################################################################
# checks for needed OS to run this scripts
# CALLED: check0S w/ <OS> (Linux or Darwin ATM)
# throws a warning if no OS is configured in config.inc.sh and checks against "Linux" and "Darwin" 
# throws an error and exits if no MANDATORY OS is found
###################################################################################################

function F__checkOS()
{
     CHECKPLATFORMS="${1}";
     if [[ ${CHECKPLATFORMS} == "osx" ]]
     then
         CHECKPLATFORMS="Darwin";
     fi
     #set platforms to linux/osx if nothing is configured
     if [[ -z ${CHECKPLATFORMS}  ]]
     then
         CHECKPLATFORMS="Linux Darwin";
         F__log "PLATFORM not set in conf using: ${CHECKPLATFORMS}" "WARN";
     else
     	F__log "${CHECKPLATFORMS} PLATFORM set in conf" "INF";
     fi
     
	 UNAMESTRING=`uname`;
	 
	 for OS in ${CHECKPLATFORMS}
	 do
	 if [[ "${UNAMESTRING}" == "${OS}" ]]; 
	 then
   		PLATFORM='${OS}';
  		FOUND="true";
  		break;    
    fi
    #echo "os checked: ${OS}";
    done
    if [[ -z ${FOUND} ]]
    then
        F__log "PLATFORM ${UNAMESTRING} not recognized ... bailing out" "ERR";        
        echo -e "${RED}ERR:${NC} PLATFORM ${UNAMESTRING} not recognized ... bailing out"
    else
         F__log "found supported ${OS} PLATFORM" "INF";
         export PLATFORM=${OS};     
    fi
            
    unset OS;
	unset UNAMESTRING;
	unset CHECKPLATFORMS;
}

###################################################################################################
# checks for neccessary root privileges
# CALLED: checkRoot "true" or "false" 
# throws a warning that root privileges would be better if called w/ "false"
# throws an error and exits if root privileges are MANDATORY if called w/ "true" or no param
###################################################################################################

function F__checkRoot()
{
   
   MUSTHAVE=${1};   
   if [[ ${LOGNAME} != "root" ]]
   then
      if [[ MUSTHAVE == "false" ]]
      then
    	F__log "dear ${F__logNAME} you should be root to use this script ... continue" "WARN";
      else
      	F__log "dear ${F__logNAME} you MUST be root to use this script properly... bailing out" "ERR";
      	exit 1;
      fi
  else
      F__log "script called w/ neccessary root privileges ... continueing" "INF";
   fi
}

###################################################################################################
# checks if not root
# CALLED: checkNonRoot "true" or "false" 
# throws a warning that non root privileges would be better if called w/ "false"
# throws an error and exits if root privileges are PROHIBITED if called w/ "true" or no param
###################################################################################################

function F__checkNonRoot()
{
   MUSTNOTHAVE=${1};
   if [[ ${LOGNAME} == "root" ]]
   then
      if [[ ${MUSTNOTHAVE} == "false" ]]
      then
        F__log "dear ${F__logNAME} you should NOT be root to use this script ... bailing out" "WARN";
      else
      	F__log "dear ${F__logNAME} NEVER be root to use this script ... bailing out" "ERR";
      exit 1;
      fi
  else
      F__log "script called w/o root privileges continuing" "INF";
   fi
}

###################################################################################################
# checks if a given dir is writeable for a ${FACILITY}
# if not tries to create it if ${CREATE} flag is set to true
# bails out if everything fails
###################################################################################################

function F__checkForDir() 
{
    FACILITY=${1};
	CHECKDIR=${2};
	CREATE=${3};
	#test if dir exists and is writeable
	if [ -d ${CHECKDIR} ]
	then 
	    if [ -w ${CHECKDIR} ]
    	then
    	    F__log "found writable ${CHECKDIR} to enable ${FACILITY}" "INF";
    	else
	    	F__log "${CHECKDIR} needed by ${FACILITY} not writable by ${USER} ...bailing out" "ERR";
   			echo -e "${RED}ERR:${NC} ${CHECKDIR} needed by ${FACILITY} not writable by ${USER} ...bailing out";
   			exit 1;
        fi   
    # if creation is enabled try to create it
	elif [ "${CREATE}" == "true" ]
    then
        if mkdir -p ${CHECKDIR};
        then
    		F__log "created ${CHECKDIR} needed by ${FACILITY}" "WARN";
    	else
    	    F__log  "could not create dir: ${CHECKDIR} needed by ${FACILITY} ...bailing out" "ERR";
    	    echo "${RED}ERR:${NC} could not create dir: ${CHECKDIR} needed by ${FACILITY} ...bailing out";
    		exit 1;
    	fi
   	fi
   	unset FACILITY;
	unset CHECKDIR;
	unset CREATE;
}

# F__logs w/ timestamp a given message to a given F__logFACILITY
# tests via function F__"checkForDir" the F__logdir
#

function F__log() 
{
	MSG="${1}";
	LOGLEVEL="${2}";
	#if no loglevel set notify user
	if [ ${LOGLEVEL} == "" ]
	then
		${LOGLEVEL} = "LOGLEVEL undefined";
	fi
	# defined in config.inc.sh
	if [ ${LOGFACILITY} == "none" ]
	then
	    # log to the big bitbucket
	    echo -e "${MSG}" > /dev/null;
	elif [ ${LOGFACILITY} == "console" ]
	then
	    #log to console and colour output
        if [ ${LOGLEVEL} == "INF" ]
	    then
	    	echo -e "${GREEN}${LOGLEVEL}:${NC}" ${MSG};
	    elif [ ${LOGLEVEL} == "WARN" ]
	    then
	        echo -e "${YELLOW}${LOGLEVEL}:${NC}" ${MSG};
	    elif [ ${LOGLEVEL} == "ERR" ]
	    then
	        echo -e "${RED}${LOGLEVEL}:${NC}" ${MSG};
	    else
	       echo -e "${CYAN}${LOGLEVEL}:${NC}" ${MSG};
	    fi	 	       	    	
	elif [ ${LOGFACILITY} == "file" ]
	then
	    #log to file and set timestamps
	    TIME=`date`;
        echo -e "[ ${TIME} ] ${LOGLEVEL}: ${MSG} \n" >> "${LOGFILE}";
    else
        # throw WARN to user + bail out
        echo -e "${RED} WARN: ${NC} configured LOGFACILITY not valid...bailing out";
        exit 1;
     fi
     #unset used vars
     unset MSG;
	 unset LOGLEVEL; 
}