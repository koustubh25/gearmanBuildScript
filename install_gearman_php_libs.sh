#!/bin/bash
#######################################################################
#This script will install the following
# pecl
# php gearman libraries
########################################################################

source GLOBAL
export PATH=$PATH:${GEARMAN_INSTALL_PREFIX}bin

# check if run as root
check_root

if which pecl>/dev/null; then
	echo "pecl already installed."
else
	read -e -p "pecl not found. Do you want to install?" -i "y" ans
	if [ "$ans" == "y" ]; then
		wget ${PHP_PEAR}
		verify_command $? "Couldn't install pear"
		php php-phar
		verify_command $? "Couldn't install pear"
		echo "pecl installed successfully"
	else
		echo "Exiting."
		exit ;
	fi
fi

echo "Now installing gearman PHP libraries"

yum -y install autoconf

pecl install gearman
verify_command $? "Error installing PHP gearman libraries"
echo "Gearman PHP libraries succesfully installed. Don't forget to add gearman.so in php.ini. Add the absolute path and verify 'php --ini' doesn't throw any errors."