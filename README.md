# Install Gearman and related dependencies on Amazon Linux

[Gearman](http://gearman.org/) is a tool used for distributed batch processing.
##Prerequisites

All the files in this repo must be kept in the same directory

##GLOBAL

"GLOBAL" file contains the list of global variables and functions used by all the scripts

##Driver script

Run the following command inside the source file directory

`sudo ./driver.sh`

The driver.sh file is interactive and you can skip instalation of tools you dont want to use

##Individual files can also be run in the following manner

`sudo ./install_php.sh` will compile and install php alongwith pear, pcntl and mysql extensions as per GLOBAL

`sudo ./install_gearman.sh` will install gearman version as mentioned in GLOBAL

`sudo ./install_gearman_manager.sh` will install [Gearman manager](https://github.com/brianlmoon/GearmanManager) based on PHP version present

`sudo ./install_gearman_ui.sh` will install [gearman web ui](http://gaspaio.github.io/gearmanui/)

##ToDo

1. Make an init script for Gearman Manager.
2. Replace yum update with only the needed packages.
