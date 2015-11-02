#!/bin/bash
#######################################################################
#This script will install the following
# pecl
# php gearman libraries
########################################################################

source GLOBAL
export PATH=$PATH:${GEARMAN_INSTALL_PREFIX}bin

if which pecl>/dev/null; then
	echo "pecl already installed."
else
	read -e -p "pecl not found. Do you want to install?" -i "y" ans
	if [ "$ans" == "y" ]; then
		wget ${PHP_PEAR}
		verify_command $? "Couldn't install pear"
		php php-phar
		verify_command $? "Couldn't install pear"
	else
		echo "Exiting."
		exit ;
	fi
fi

echo "pear installed successfully. Now installing gearman PHP libraries"

pecl install gearman
verify_command $? "Error installing PHP gearman libraries"
echo "Gearman PHP libraries succesfully installed"