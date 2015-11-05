#!/bin/bash
#######################################################################
#This script installs geramanui from https://github.com/gaspaio/gearmanui
########################################################################

source GLOBAL

check_root

#check php
if hash php 2>\dev\null; then
	echo "PHP found."
else
	./install_php.sh
fi

cd $GEARMAN_UI_DIR

echo 'Checking Composer...'
check_composer

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

echo "
Now installing bower globally..."

if ! hash bower 2>/dev/null; then
	npm -g install bower
fi

bower install --allow-root
verify_command $? "Error installing gearmanui."
cp config.yml.dist config.yml
verify_command $? "Error copying config files."

echo "Gearman successfully installed. Make sure to add ${GEARMAN_UI_DIR}gearmanui/web in the Document root of your web server. 
Check ${GEARMAN_UI_DOCS} for more information."

