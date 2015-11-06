#!/bin/bash

source GLOBAL

# check if run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

read -p "
Depending on the machine, it may take upto 60 minutes for the entire driver script to finish executing. Press any key to continue." a

read -e -p "
Will the Gearman Job server run on this machine? This is necessary even if you wish to use this machine as just a gearman client. " -i "y" ans
if [ "$ans" == "y" ]; then  
	./install_gearman.sh
	verify_command $? "Error installing Gearman"
fi

read -e -p "
Do you want to set up Gearman Web UI? " -i "y" ans
if [ "$ans" == "y" ]; then  
	./install_gearman_ui.sh 
	verify_command $? "Error setting up Gearman web ui"
fi


read -e -p "
Will the Gearman Workers run here?
(If this machine only runs as a Job Server, no need to install Gearman Manager) " -i "y" ans
if [ "$ans" == "y" ]; then 
	./install_gearman_manager.sh
	verify_command $? "Error installing Gearman"
fi

read -e -p "
Do you want to install PHP libraries? " -i "y" ans
if [ "$ans" == "y" ]; then 
	./install_gearman_php_libs.sh
	verify_command $? "Error installing Gearman PHP libraries"
fi

echo "Driver script has now ended."