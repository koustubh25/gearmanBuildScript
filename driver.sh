#!/bin/bash

source GLOBAL

# check if run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cd $GEARMAN_BUILD_SCRIPT
read -e -p "will the Gearman Job server run on this machine?" -i "y" ans 
if [ "$ans" == "y" ]; then  
	./install_gearman.sh
	verify_command $? "Error installing Gearman"
fi

read -e -p "Do you want to set up Gearman Web UI?(y)" -i "y" ans
if [ "$ans" == "y" ]; then  
	./install_gearman_ui.sh 
	verify_command $? "Error setting up Gearman web ui"
fi


read -e -p "Will the Gearman Workers run here? 
(If this machine only runs as a Job Server, no need to install Gearman Manager) " -i "y" ans
if [ "$ans" == "y" ]; then 
	./install_gearman_manager.sh
	verify_command $? "Error installing Gearman"
fi

read -e -p "Do you want to install PHP libraries(y)" -i "y" ans
if [ "$ans" == "y" ]; then 
	./install_gearman_php_libs.sh
	verify_command $? "Error installing Gearman PHP libraries"
fi

echo "Driver script has now ended."
