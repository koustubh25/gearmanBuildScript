#!/bin/bash
###############################################################
#This script will install the following alongwith its dependencies
# Gearman
######################################################################

source GLOBAL

# check if run as root
check_root

read -p "This script compiles the source code for gearman. Depending on the machine, it could take upto 30 minutes for the script to complete. Press any key to continue." a

#Remove if installable exists
echo "Removing existing installables if present in ${GEARMAN_DOWNLOAD_DIR}"

rm -rf ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION} ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}.tar.gz
verify_command $? "Error cleaning up previous Gearman downloads"

cd $GEARMAN_DOWNLOAD_DIR 

echo "This script will now download and install Gearman version ${GEARMAN_VERSION}..."
printf "Now downloading Gearman from ${GEARMAN_INSTALLABLE}... "

#Download

wget $GEARMAN_INSTALLABLE 
verify_command $? "Error downloading"
sleep 5
printf "Extracting:"
tar -xzf gearmand-${GEARMAN_VERSION}.tar.gz
verify_command $? "Error downloading and untarring."
rm -rf gearmand-${GEARMAN_VERSION}.tar.gz

#update repositories
yum -y update boost-devel

#Perisistent QUEUE
read -p  "Now preparing configration. 
Enter you preferred Persistent queue libraries to install(1) 
1. MySQL 
2. Memcached 
3. Both " choiceDB
case $choiceDB in
    "1")
    	install_program "mysql" "mysql" 
		echo "Now installing necessary libraries for mysql"
		yum -y install mysql-devel
		verify_command $? "Error installing mysql-devel"
		;;
    "2") 
		install_program "memcached" "memcache"
		yum -y install memcached libmemcached libmemcached-devel;
		verify_command $? "Error installing memcache libraries"
		;;
	"3")
		install_program "mysql" "mysql"
		echo "Now installing necessary libraries for mysql"
		yum -y install mysql-devel;
		verify_command $? "Error installing mysql-devel"
		install_program "memcached" "memcache"
		yum -y install memcached libmemcached libmemcached-devel;
		verify_command $? "Error installing memcache libraries"
		;;
	*) 
		exit 1;
		;;

esac

echo "Installing Gearman dependencies..."
sudo yum -y install libevent-devel gcc-c++ boost-devel libuuid-devel gperf
verify_command $? "Error installing Gearman dependencies"

#Configure Gearman
echo "Now configuring Gearman..."
cd ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}
configure="${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}/configure 
	--prefix=${GEARMAN_INSTALL_PREFIX}
	--disable-libdrizzle";

if [ $choiceDB -eq 1 ]; then
	configure="${configure} --disable-libmemcached --with-mysql"; 
elif [ $choiceDB -eq 2 ]; then
	configure="${configure} --disable-libmemcached --with-libmemcached";
else
	configure="${configure} --with-libmemcached --with-mysql"
fi

$configure
verify_command $? "Error while configuring."	
echo "Please check Gearman configuration."

read -p "Press any key" a

echo "Now installing gearman..."

cd ${GEARMAN_DOWNLOAD_DIR}gearmand-${GEARMAN_VERSION}
make
make install
verify_command $? "Failed to install Gearman.."

ldconfig

echo "You can start gearman by runnning the command 'gearmand'. 
Gearman config file (${GEARMAN_INSTALL_PREFIX}etc/gearmand.conf) or check command line options gearmand -h"


