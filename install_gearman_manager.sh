#!/bin/bash
################################################################################
#This script installs geramanui from https://github.com/brianlmoon/GearmanManager
#pcntl
################################################################################

source GLOBAL

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
		./install_php.sh
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

	echo "
	Make sure to add absolute path of pcntl.so in php.ini file"

fi

echo "Adding Gearman manager as service"



rm -rf ${PHP_SOURCE_URL}php-${PHP_VERSION_FOUND}*