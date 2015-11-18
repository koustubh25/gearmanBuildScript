#!/bin/bash
###############################################################
#This script will install the following alongwith its dependencies
# Gearman
######################################################################



# check if run as root
check_root

SCRIPT_DIR=$(pwd)
source $SCRIPT_DIR/../GLOBAL

#Remove if installable exists
echo "Removing existing installables if present in ${GEARMAN_DOWNLOAD_DIR}"

rm -rf ${GEARMAN_DOWNLOAD_DIR}/gearmand-${GEARMAN_VERSION} ${GEARMAN_DOWNLOAD_DIR}/gearmand-${GEARMAN_VERSION}.tar.gz
verify_command $? "Error cleaning up previous Gearman downloads"

cd $GEARMAN_DOWNLOAD_DIR 

echo "This script will now download and install Gearman version ${GEARMAN_VERSION}..."
printf "Now downloading Gearman from ${GEARMAN_INSTALLABLE}... "

#Download
wget $GEARMAN_INSTALLABLE 
verify_command $? "Error downloading"

printf "Extracting:"
tar -xzf gearmand-${GEARMAN_VERSION}.tar.gz
verify_command $? "Error downloading and untarring."
rm -rf gearmand-${GEARMAN_VERSION}.tar.gz

#update repositories
yum -y update

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
		echo "Invalid option. Exiting..."
		exit 1;
		;;

esac

echo "Installing Gearman dependencies..."
sudo yum -y install libevent-devel gcc-c++ boost-devel libuuid-devel gperf
verify_command $? "Error installing Gearman dependencies"

#Configure Gearman
echo "Now configuring Gearman..."
cd ${GEARMAN_DOWNLOAD_DIR}/gearmand-${GEARMAN_VERSION}
configure="${GEARMAN_DOWNLOAD_DIR}/gearmand-${GEARMAN_VERSION}/configure 
	--prefix=${GEARMAN_INSTALL_PREFIX}
	--disable-libdrizzle
	--sysconfdir=$GEARMAN_CONF_FILE_DIR";

if [ $choiceDB -eq 1 ]; then
	configure="${configure} --disable-libmemcached --with-mysql"; 
elif [ $choiceDB -eq 2 ]; then
	configure="${configure} --disable-mysql --with-libmemcached";
elif [ $choiceDB -eq 3 ]; then
	configure="${configure} --with-libmemcached --with-mysql"
else
	configure="${configure} --disable-libmemcached --disable-libmysql";
fi

$configure
verify_command $? "Error while configuring."	
echo "Please check Gearman configuration."

read -p "Press any key" a

echo "Now installing gearman..."

cd ${GEARMAN_DOWNLOAD_DIR}/gearmand-${GEARMAN_VERSION}
make
make install
verify_command $? "Failed to install Gearman.."

ldconfig

cp $SCRIPT_DIR/gearmand.conf $GEARMAN_CONF_FILE_DIR

sed -i "s@\$GEARMAN_INSTALL_PREFIX/@${GEARMAN_INSTALL_PREFIX}@" $SCRIPT_DIR/gearmand.init
sed -i "s/gearman_user/$GEARMAN_USER/g" $SCRIPT_DIR/gearmand.init
sed -i 's:/usr/sbin/gearmand:/usr/local/sbin/gearmand:' $SCRIPT_DIR/gearmand.init
cp $SCRIPT_DIR/gearmand.init /etc/init.d/gearmand
chmod a+x /etc/init.d/gearmand
chkconfig gearmand on

rm -rf gearmand-${GEARMAN_VERSION}*

echo "You can start gearman by runnning  'sudo service gearmand start'.
Gearman config file (${GEARMAN_CONF_FILE_DIR}/gearmand.conf). Check command line options gearmand -h"


