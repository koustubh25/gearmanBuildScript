#!/bin/bash

#Driver Script for Setting up Gearman and related tools on Amazon Linux

source GLOBAL

# check if run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

yum -y install dialog

cmd=(dialog --title "Setting up Gearman and related tools on Amazon Linux" --separate-output --checklist "Select items you want to set up:" 22 76 16)
options=(1 "Gearman Server with MySql as Persistent queue" on    
         2 "Gearman Server with Memcache as Persistent queue" off
         3 "Gearman Manager" on
         4 "Gearman UI" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear

current_dir=$(pwd)

for choice in $choices
do
    case $choice in
        1)
        	echo "Now installing Geraman with Mysql..."
        	cd $current_dir/gearman
            ./install_gearman.sh 1
			verify_command $? "Error installing Gearman"
            ;;
        2)
        	echo "Now installing Geraman with Memcache..."
            cd $current_dir/gearman
            ./install_gearman.sh 2
			verify_command $? "Error installing Gearman"
            ;;
        3)
            echo "Now installing Geraman Manager..."
            cd $current_dir/gearman_manager
            ./install_gearman_manager.sh
			verify_command $? "Error installing Gearman Manager"
            ;;
        4)
            echo "Now setting up Gearman UI..."
            cd $current_dir/gearmanui
            ./install_gearman_ui.sh 
			verify_command $? "Error setting up Gearman web ui"
            ;;
    esac
done

echo "Driver script has now ended."