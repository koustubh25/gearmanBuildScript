#!/bin/bash
###############################################################
#This script will install the following alongwith its dependencies
# Gearman
######################################################################

source config


verify_command(){
	if [ $1 -eq 0 ]; then
			echo $DONE
		else
			echo "Failed to install memcache libraries"
			echo $ERROR
			echo $2
			exit 1;
		fi

}

# check if run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "This script will now download and install Gearman version ${GEARMAN_VERSION} .."
printf "Now downloading Gearman from ${GEARMAN_INSTALLABLE} .. "


#Download
sudo wget -q $GEARMAN_INSTALLABLE -P $GEARMAN_DOWNLOAD_DIR
verify_command $? "Cannot download source. Please check the path."


#Extract
printf "Extracting:"
printf "${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}.tar.gz .. "
echo "sudo tar -xzf ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}.tar.gz"
tar -xzf ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}.tar.gz -C ${GEARMAN_DOWNLOAD_DIR}; 
verify_command $? "Error untarring .."

#Perisistent QUEUE
read -p  "Now preparing configration. 
Enter you preferred Persistent queue libraries to install(1) 
1. MySQL 
2. Memcached 
3. Both " choiceDB
case $choiceDB in
    "1")
		sudo yum -y install mysql-devel;
		verify_command $?
		;;
    "2" | "3") 
		sudo yum -y install memcached libmemcached libmemcached-devel;
		verify_command $? "Error installing memcache librraies"
		;;
		*) ;;

esac

echo "Installing Gearman dependencies .."
sudo yum -y install libevent-devel gcc-c++ boost-devel libuuid-devel gperf
verify_command $? "Error installing Gearman dependencies"

#Configure Gearman
echo "Now configuring Gearman .."
cd ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}
configure="${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}/configure 
	--prefix=${GEARMAN_INSTALL_PREFIX}
	--disable-libdrizzle";

if [ $choiceDB -eq 1 ]; then
	configure="${configure} --disable-libmemcached --with-mysql"; 
elif [ $choiceDB -eq 2]; then
	configure="${configure} --disable-libmemcached --with-libmemcached";
else
	configure="${configure} --with-libmemcached --with-mysql"
	exit 1;
fi

$configure
verify_command $? "Error while configuring."	
echo "Please check Gearman configuration."

read -p "Press any key" a

echo "Now installing gearman .."

${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}/make
${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}/make install

verify_command $? "Failed to install .."

echo "You can start gearman by runnning the command 'gearmand'. 
Gearman config file (/usr/local/etc/gearmand.conf) or 
check command line options gearmand -h"


