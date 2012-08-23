#!/bin/bash
####################################################################################################
# author: arnd (at) netzturbine (dot) de                                                           #
# version 0.1b                                                                                     #
# description: script sets up java alternatives links                                              #
# it is part of a collection of helper scripts I used to quick setup an android build environment  #
####################################################################################################

# put the path to your downloaded + installed jre
JAVA_HOME="/usr/java/jdk1.6.0_33";

OLD_JAVAHOME=`update-alternatives --query java | grep ${JAVA_HOME} | wc -l`;
OLD_JAVACHOME=`update-alternatives --query javac | grep ${JAVA_HOME} | wc -l`; 

if [ ${OLD_JAVAHOME} -gt 0 ]
then

  #remove conflicting configurations
  echo "found old configuration for ${JAVA_HOME}"
  update-alternatives --remove java $JAVA_HOME/bin/java;
else
   echo "no old ${JAVA_HOME} found";
fi

if [ ${OLD_JAVACHOME} -gt 0 ]
then
    echo "found old configuration for javac pointing to ${JAVA_HOME}"
    update-alternatives --remove javac $JAVA_HOME/bin/javac;
else
    echo "no old ${JAVA_HOME} found configuring new javac";
fi



echo "JAVAHOME used: ${JAVA_HOME}";

echo "setting java jdk and slaves javadoc,jar,keytool";

update-alternatives \
--install /usr/bin/java java ${JAVA_HOME}/bin/java 1 \
--slave /usr/bin/keytool keytool ${JAVA_HOME}/bin/keytool \
--slave /usr/bin/policytool policytool ${JAVA_HOME}/bin/policytool \
--slave /usr/bin/orbd orbd ${JAVA_HOME}/bin/orbd \
--slave /usr/bin/rmi rmi ${JAVA_HOME}/bin/rmi \
--slave /usr/bin/rmiregistry rmiregistry ${JAVA_HOME}/bin/rmiregistry \
--slave /usr/bin/servertool servertool ${JAVA_HOME}/bin/servertool \
--slave /usr/bin/tnameserv tnameserv ${JAVA_HOME}/bin/tnameserv
#--slave JRE ${JAVA_HOME}/jre/;

update-alternatives \
--install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1 \
--slave /usr/bin/jar jar ${JAVA_HOME}/bin/jar \
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


echo "activating new config";

update-alternatives --set java $JAVA_HOME/bin/java;

update-alternatives --set javac $JAVA_HOME/bin/javac;

