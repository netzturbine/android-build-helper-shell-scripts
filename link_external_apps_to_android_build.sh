#! /bin/bash
#############################################################################
# author: arnd (at) netzturbine (dot) de
# version 0.1b
# description: script links external apps to android buildsystem to include them in builds
# it is part of a collection of helper scripts I used to quick setup an android build environment
#
# LAYOUT reflected in configuration:
#
# <COMPILE_ROOT>                - location containing Your builddirectory(s) !!!!needs to be defined in config.libsh!!!!
# |_bin                         - scriptdirectory
# | |_config.inc.sh                - config of global vars
# | |_functions.lib.sh           - definition of reusable shell funtions ie debugging/logging/testing
# | |_<THISSCRIPT>              - script
# | |_<THISSCRIPT>.log          - script log if logging is enabled
# | |_.....                     - more scripts/more logs  
# |_system -> ./system_X        - symlink to your intended default build or existing directory
# |_system_X                    - build 'X' (cm10)
# |_system_Y                    - build 'Y' (google jellybean)
# |_....                        - more builds....
# |_system_Z                    - stripped build
# |
# |_additional_apps             - directory which contains packages or sources of apps
#   |_packages                  - directory containing all packages
#   | |_active                  - directory containing symlinks to active packages
#   |   |<PACKAGE>
#   |_sources
#     |_active                   - directory containing symlinks to active sources
#       |_<PACKAGE>              - directory containing all sources
#############################################################################

# check if configfile 'config.inc' exists and
# source global $VARS

if -f config.inc.sh
then
    source config.inc.sh;
    MSG=$MSG "found config";
else
    echo -e "ERR: could not find config ...bailing out";
    exit 1;
fi

usage(){
	echo -e "script links external apps to android buildsystem to include them in builds";
    echo -e "it is part of a collection of helper scripts I used to quick setup an android build environment";
	echo -e "options:";
	echo -e "--all: all builds will be linked w/ app";
	echo -e "";
	echo -e "";
    exit 0;
}

#define local script vars
#DEBUG=true;
#LOG="";

APP_ROOT=" ${ABH_COMPILE_ROOT}/additional_apps";
SOURCES_ROOT="${APP_ROOT}/sources";
PACKAGES_ROOT="${APP_ROOT}/packages"; 
ACTIVE_APPS="${APP_ROOT}/active";

SOURCE_APPS="ownCloud " #DroidWall FDroid";
PACKAGE_APPS="Fennec";

#build menu
case ${1} in
    "--all" )
    	BUILDLIST="${ABH_DEFAULT_BUILD_DIR} ${ABH_ADDITIONAL_BUILD_DIRS}"; 
	    echo -e "all configured builds ${BUILDLIST} will be linked";
	    ;;
	"--default" )
	    BUILDLIST="${ABH_DEFAULT_BUILD_DIR}";  
	    echo -e "configured default build ${BUILDLIST} will be linked";
	    ;;
    "--build" )
	    echo -e "build ${2} will be linked";
	    BUILDLIST="${2}";   
	    ;;
	"--show default" )
	    echo -e "configured default build dir in ${ABH_COMPILE_ROOT} is ${ABH_COMPILE_ROOT}"; 
	    exit 0;
	    ;;
	"--list builds" )
	    echo -e "Listing existing build dirs in ${ABH_COMPILE_ROOT}:"; 
	    ls ${ABH_COMPILE_ROOT} | grep "system";
	    exit 0;
	    ;;
	"--list linked apps" )
	    echo -e "linked apps in ${ACTIVE_APPS}:"; 
	    ls ${ACTIVE_APPS};
	    exit 0;
	    ;;
	"--list all apps" )
	    echo -e "existing apps in ${SOURCES_ROOT}:"; 
	    ls ${SOURCES_ROOT};
	    echo -e "existing apps in ${PACKAGES_ROOT}:"; 
	    ls ${PACKAGES_ROOT};
	    exit 0;
	    ;;
	* )
	    usage;
	    ;;
esac
#apps menu
case ${2} in
    "--all" )
	    log "all configured apps ${SOURCE_APPS} ${PACKAGE_APPS} will be linked to ${BUILDLIST}";
	    APPLIST="${ABH_DEFAULT_BUILD_DIR} ${ABH_ADDITIONAL_BUILD_DIRS}"; 
	    ;;
	"--app" )
	    log "app ${$} will be linked to ${BUILDLIST}";
	    APPLIST="${3}";  
	    ;;
	* )
		case ${3} in
    		"--all" )
	   			log "all configured apps ${SOURCE_APPS} ${PACKAGE_APPS} will be linked to ${BUILDLIST}";
	    		APPLIST="${ABH_DEFAULT_BUILD_DIR} ${ABH_ADDITIONAL_BUILD_DIRS}"; 
	   		 ;;
			"--app" )
	    		log "app ${3} will be linked to ${BUILDLIST}";
	    		APPLIST="${3}";  
	    	;;
	    	* )
	    		usage;
	    	;;
	    esac
	    ;;
esac

for BUILD IN ${BUILDLIST}
do
   DEST="${COMPILE_ROOT}/${BUILD}/packages/apps/";
   for APP in ${APPLIST}
   do
      if [ ! -f ${ACTIVE_APPS}/${APP}/Android.mk ]
      then
            log "${APP} needs Android.mk file to be included in build - NOT LINKING IT" "WARN"
      else
      		if ln -s ${ACTIVE_APPS}/${APP} ${DEST}/${APP}
      		then
      		   log "linked ${APP} in ${BUILD}" "INF";
      		else
      		   log "could not link ${APP} in ${BUILD}" "WARN";
      		fi
      fi
   done
done 

echo -e "now invoke mm in the resp. DIRS";