#!/bin/bash
####################################################################################################
# author: arnd (at) netzturbine (dot) de                                                           #
# version 0.1b                                                                                     #
# description: script sets up java alternatives links                                              #
# it is part of a collection of helper scripts I used to quick setup an android build environment  #
####################################################################################################

#include config needed by script
if [ -f config.inc.sh ]
then
    source config.inc.sh;
    MSG="$MSG found config";
else
    echo -e "ERR: could not find config ...bailing out";
    exit 1;
fi

#check os arch
ARCH=$(uname -a | grep 64 | wc -l);

if [[ ${ARCH} -gt 0 ]]
then
         LIBPATH="/usr/lib64";
         PLUGINPATH="amd64";
         echo -e "\nfound 64bit system \n"
else
         LIBPATH="/usr/lib";
         PLUGINPATH="i386";
         echo -e "\nno 64bit system using i386 system layout \n"
fi

echo -e "\nconfigured LIBPATH as ${LIBPATH}\n"
echo -e "\nconfigured PLUGINPATH as ${PLUGINPATH}\n"

# path to your downloaded + installed jdk/jre
JAVA_HOME="/usr/java/latest";
JRE_HOME="/usr/java/latest/jre";

OLD_JAVAHOME=`update-alternatives --query java | grep ${JAVA_HOME} | wc -l`;
OLD_JAVACHOME=`update-alternatives --query javac | grep ${JAVA_HOME} | wc -l`; 
OLD_BROWSERPLUGIN=`update-alternatives --query javaplugin | grep ${JRE_HOME} | wc -l`; 

if [ ${OLD_JAVAHOME} -gt 0 ]
then

  #remove conflicting configurations
  echo -e "\nfound old configuration for ${JAVA_HOME}"
  update-alternatives --remove java $JAVA_HOME/bin/java;
else
   echo -e "no old ${JAVA_HOME} found";
fi

if [ ${OLD_JAVACHOME} -gt 0 ]
then
    echo -e "\nfound old configuration for javac pointing to ${JAVA_HOME}"
    update-alternatives --remove javac $JAVA_HOME/bin/javac;
else
    echo -e "no old ${JAVA_HOME} found configuring new javac";
fi

if [ ${OLD_BROWSERPLUGIN} -gt 0 ]
then
    echo -e "\nfound old configuration for javaplugin pointing to ${JRE_HOME}"
    update-alternatives --remove javaplugin ${JRE_HOME}/lib/amd64/libnpjp2.so;
else
    echo -e "no old ${JRE_HOME} found configuring new javaplugin";
fi

echo -e "\nJAVAHOME used: ${JAVA_HOME}";
echo -e "JREHOME used: ${JRE_HOME}\n";

echo -e "installing config JAVA w/ dirs java jre jre_exports and binaries keytool,policytool,orbd,rmiregistry,servetool,tnameserv\n";

update-alternatives \
--install /usr/bin/java java ${JAVA_HOME}/bin/java 1 \
--slave ${LIBPATH}/jvm/jre jre ${JRE_HOME} \
--slave ${LIBPATH}/jvm-exports/jre jre_exports ${JRE_HOME} \
--slave /usr/bin/keytool keytool ${JAVA_HOME}/bin/keytool \
--slave /usr/bin/policytool policytool ${JAVA_HOME}/bin/policytool \
--slave /usr/bin/orbd orbd ${JAVA_HOME}/bin/orbd \
--slave /usr/bin/rmiregistry rmiregistry ${JAVA_HOME}/bin/rmiregistry \
--slave /usr/bin/servertool servertool ${JAVA_HOME}/bin/servertool \
--slave /usr/bin/tnameserv tnameserv ${JAVA_HOME}/bin/tnameserv \

echo -e "installing config JRE w/ dirs java_sdk jvm-exports and binaries jar, jarsigner...a lot ;)\n";

update-alternatives \
--install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1 \
--slave ${LIBPATH}/jvm/java java_sdk ${JAVA_HOME} \
--slave ${LIBPATH}/jvm-exports/java java_sdk_exports ${JAVA_HOME}/ \
--slave /usr/bin/jar jar ${JAVA_HOME}/bin/jar \
--slave /usr/bin/jarsigner jarsigner ${JAVA_HOME}/bin/jarsigner \
--slave /usr/bin/javadoc javadoc ${JAVA_HOME}/bin/javadoc \
--slave /usr/bin/javah javah ${JAVA_HOME}/bin/javah \
--slave /usr/bin/javap javap ${JAVA_HOME}/bin/javap \
--slave /usr/bin/jconsole jconsole ${JAVA_HOME}/bin/jconsole \
--slave /usr/bin/jdb jdb ${JAVA_HOME}/bin/jdb \
--slave /usr/bin/jhat jhat ${JAVA_HOME}/bin/jhat \
--slave /usr/bin/jinfo jinfo ${JAVA_HOME}/bin/jinfo \
--slave /usr/bin/jmap jmap ${JAVA_HOME}/bin/jmap \
--slave /usr/bin/jps jps ${JAVA_HOME}/bin/jps \
--slave /usr/bin/jrunscript jrunscript ${JAVA_HOME}/bin/jrunscript \
--slave /usr/bin/jsadebugd jsadebugd ${JAVA_HOME}/bin/jsadebugd \
--slave /usr/bin/jstack jstack ${JAVA_HOME}/bin/jstack \
--slave /usr/bin/jstat jstat ${JAVA_HOME}/bin/jstat \
--slave /usr/bin/jstatd jstatd ${JAVA_HOME}/bin/jstatd \
--slave /usr/bin/native2ascii native2ascii ${JAVA_HOME}/bin/native2ascii \
--slave /usr/bin/pack200 pack200 ${JAVA_HOME}/bin/pack200 \
--slave /usr/bin/rmic rmic ${JAVA_HOME}/bin/rmic \
--slave /usr/bin/schemagen schemagen ${JAVA_HOME}/bin/schemagen \
--slave /usr/bin/serialver serialver ${JAVA_HOME}/bin/serialver \
--slave /usr/bin/unpack200 unpack200 ${JAVA_HOME}/bin/unpack200 \
--slave /usr/bin/wsgen wsgen ${JAVA_HOME}/bin/wsgen \
--slave /usr/bin/wsimport wsimport ${JAVA_HOME}/bin/wsimport \

echo -e "installing config JAVAPLUGIN w/ binary javaws\n";

update-alternatives \
--install /usr/lib/browser-plugins/javaplugin.so javaplugin ${JRE_HOME}/lib/${PLUGINPATH}/libnpjp2.so 1 \
--slave /usr/bin/javaws javaws ${JRE_HOME}/bin/javaws


echo -e "activating new configs\n";

update-alternatives --set java $JAVA_HOME/bin/java;

update-alternatives --set javac $JAVA_HOME/bin/javac;

update-alternatives --set javaplugin ${JRE_HOME}/lib/amd64/libnpjp2.so

echo -e "\ndisplaying installed versions of binaries\n"

java -version;

javac -version;

