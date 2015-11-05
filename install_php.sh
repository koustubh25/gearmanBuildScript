#!/bin/bash
################################
#installing PHP as per CONFIG file
################################ 

source GLOBAL

check_root

yum -y install gcc-c++ openssl-devel

#Cleanup prevous installables if exist
rm -rf ${PHP_DOWNLOAD_DIR}php-${PHP_VERSION}.tar.gz ${PHP_DOWNLOAD_DIR}php-${PHP_VERSION}

read -e -p "PHP ${PHP_VERSION} will be downloaded and installed. Continue?" -i "y" ans
if [ "$ans" != "y" ]; then
	echo "Exiting..."
	exit 1;
fi


#Download PHP source code
printf "Downloading PHP source code..." 
wget -q ${PHP_SOURCE_URL}php-${PHP_VERSION}.tar.gz -P ${PHP_DOWNLOAD_DIR}
verify_command $? "Error downloading PHP source code"

cd ${PHP_DOWNLOAD_DIR}

#untar
printf "Extracting..."
tar -xzf php-${PHP_VERSION}.tar.gz
verify_command $? "Error downloading PHP source code"

rm -rf ${PHP_DOWNLOAD_DIR}php-${PHP_VERSION}.tar.gz

cd php-${PHP_VERSION}

sudo yum -y install libxml2-devel

./configure --prefix=/usr/local/ --enable-pcntl --with-mysql --with-pear --with-openssl
verify_command $? "Error configuring PHP build"

make
verify_command $? "Error building PHP "

make install
verify_command $? "Error building PHP "

echo "PHP ${PHP_VERSION} has now been installed ."




