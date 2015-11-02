#!/bin/bash
#######################################################################
#This script installs geramanui from https://github.com/gaspaio/gearmanui
########################################################################

source GLOBAL
export PATH=$PATH:${GEARMAN_INSTALL_PREFIX}bin

cd $GEARMAN_UI_DIR

#check php
install_program "php" "php"

echo 'Checking Composer ..'
if which composer>/dev/null; then
    echo "composer exists"
else
	read -e -p "composer not installed. Do you want to install?" -i "y" ans
	#install composer globally
	if [ "$ans" == "y" ]; then
		echo "Checking curl"
		install_program "curl" "curl"
		curl -sS ${COMPOSER_URL} | ${PHP_PATH}
		verify_command $? "Error installing $1"
		mv composer.phar ${GEARMAN_INSTALL_PREFIX}bin/composer
		echo "Composer installed globally"
	else
		echo "Exiting .."
		exit 1;
	fi
fi

install_program "git" "git-core"

#clean gearman ui if already present
rm -rf gearmanui

git clone ${GEARMAN_UI_SOURCE}
verify_command $? "Error cloning gearman-ui"
cd gearmanui
composer install --no-dev
verify_command $? "Error installing gearmanui dependencies."

install_program "npm" "npm --enablerepo=epel"
verify_command $? "Error installing npm."

echo "Now installing bower globally .."

npm -g install bower

bower install --allow-root
verify_command $? "Error installing gearmanui."
cp config.yml.dist config.yml
verify_command $? "Error copying config files."

echo "Gearman successfully installed. Make sure to add ${GEARMAN_UI_DIR}gearmanui/web in the Document root of your web server. 
Check ${GEARMAN_UI_DOCS} for more information."

