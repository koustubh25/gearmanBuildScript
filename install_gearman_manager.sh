#!/bin/bash
################################################################################
#This script installs geramanui from https://github.com/brianlmoon/GearmanManager
#pcntl
################################################################################

source GLOBAL
export PATH=$PATH:${GEARMAN_INSTALL_PREFIX}bin

cd ${GEARMAN_MANAGER_DIR}
install_program "git" "git-core"

#check php version
install_program "php" "php"
echo "checking PHP version .."
PHP_VERSION_FOUND=$(php -v|grep --only-matching --perl-regexp "5\.\\d+\.\\d+")
version=$(compare_versions GEARMAN_MANAGER_MASTER_BRANCH_VERSION PHP_VERSION_FOUND)

rm -rf ${GearmanManager}GearmanManager

if [ "$versions" == "new" ];then
	#clone from master branch
	
	git clone ${GEARMAN_MANAAGER_SOURCE}
	composer
else
	git clone -b v2 ${GEARMAN_MANAAGER_SOURCE}
fi

echo "You need pecl installed to use Gearman Manager. Checking if pecl installed .."


	