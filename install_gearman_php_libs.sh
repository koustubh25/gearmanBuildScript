#!/bin/bash
#######################################################################
#This script will install the following
# pecl
# php gearman libraries
########################################################################

source GLOBAL

# check if run as root
check_root

if hash pecl 2>/dev/null; then
	echo "pecl already installed."
else
	read -e -p "pecl not found. Do you want to install?" -i "y" ans
	rm -rf ${PHP_PEAR}
	if [ "$ans" == "y" ]; then
		wget ${PHP_PEAR}
		verify_command $? "Couldn't install pear"
		php go-pear.phar
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
echo "
Gearman PHP libraries succesfully installed. Don't forget to add absolute path of gearman.so in php.ini. Verify 'php --ini' doesn't throw any errors."