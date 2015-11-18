#!/bin/bash
################################################################################
#This script installs Gearman Ganager from https://github.com/brianlmoon/GearmanManager
#pcntl in PHP
################################################################################

SCRIPT_DIR=$(pwd)
source $SCRIPT_DIR/../GLOBAL

# check if run as root
check_root

install_program "git" "git-core"

#check php version
if hash php 2>/dev/null; then
	echo "PHP found."
else
	read -e -p "
	This script needs PHP. Press y to install" -i "y" ans
	if [ "$ans" == "y" ]; then
		source $SCRIPT_DIR/../install_php.sh
	else
		echo "Exiting..."
		exit 1;
	fi
fi

echo "checking PHP version..."
PHP_VERSION_FOUND=$(php -v|grep --only-matching --perl-regexp "5\.\\d+\.\\d+")
version=$(compare_versions $GEARMAN_MANAGER_MASTER_BRANCH_VERSION $PHP_VERSION_FOUND)

cd ${GEARMAN_MANAGER_DOWNLOAD_DIR}

rm -rf ${GearmanManager}GearmanManager

if [ "$version" == "new" ]; then
	
	#clone from master branch	
	git clone ${GEARMAN_MANAGER_SOURCE}
	cd GearmanManager
	check_composer
	composer install --no-dev
else
	#clone v2
	git clone -b v2 ${GEARMAN_MANAGER_SOURCE}

	read -e -p "
	You need pcntl enabled in php to use gearman manager. Press y to continue." -i "y" ans
	if [ "$ans" != "y" ];then
		exit 1;
	fi

	cd ${PHP_SOURCE_DIR}

	#Clean previous	
	rm -rf ${PHP_SOURCE_URL}php-${PHP_VERSION_FOUND}*

	#Download
	wget ${PHP_SOURCE_URL}php-${PHP_VERSION_FOUND}.tar.gz

	#Extract
	printf "Extracting:"
	tar -xzf php-${PHP_VERSION_FOUND}.tar.gz
	verify_command $? "Error untarring php source..."

	#Delete tar ball
	rm -rf ${PHP_SOURCE_URL}php-${PHP_VERSION_FOUND}.tar.gz

	cd php-${PHP_VERSION_FOUND}/ext/pcntl
	phpize
	verify_command $? "Error with phpize"
	./configure
	verify_command $? "Error configuring php pcntl"
	make install
	verify_command $? "Error installing php pcntl"

	read -p "
	Please add pcntl.so in php.ini file" a

fi

source $SCRIPT_DIR/../install_gearman_php_libs.sh

echo "Adding Gearman manager as service"

sed -i "s@GEARMAN_MANAGER_DOWNLOAD_DIR/@${GEARMAN_MANAGER_DOWNLOAD_DIR}@" ${SCRIPT_DIR}/gearman_manager.init
sed -i "s@GEARMAN_MANAGER_CONF/@${GEARMAN_MANAGER_CONF}@" ${SCRIPT_DIR}/gearman_manager.init
sed -i "s@GEARMAN_MANAGER_USER/@${GEARMAN_MANAGER_USER}@"  ${SCRIPT_DIR}/gearman_manager.init

sed -i "s@GEARMAN_MANAGER_DOWNLOAD_DIR/@${GEARMAN_MANAGER_DOWNLOAD_DIR}@" ${SCRIPT_DIR}/gearman_manager_conf.ini
sed -i "s@GEARMAN_MANAGER_LOG/@${GEARMAN_MANAGER_LOG}@" ${SCRIPT_DIR}/gearman_manager_conf.ini

echo "Copying Gearman Manager conf file"
cp ${SCRIPT_DIR}/gearman_manager_conf.ini ${GEARMAN_MANAGER_CONF}
verify_command $? "Error copying gearman manager conf file"

echo "Copying Gearman Manager init script"
cp ${SCRIPT_DIR}/gearman_manager.init /etc/init.d/gearman-manager
verify_command $? "Error copying gearman manager init script"

chmod +x /etc/init.d/gearman-manager

echo "You can now run 'sudo service gearman-manager start' if pcntl has been enabled in php and PHP gearman libraries are installed"

rm -rf ${PHP_SOURCE_URL}php-${PHP_VERSION_FOUND}*