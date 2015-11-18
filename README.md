# Install Gearman and related dependencies on Amazon Linux

[Gearman](http://gearman.org/) is a tool used for distributed batch processing.
##Prerequisites

All the files in this repo must be kept in the same directory

##GLOBAL

"GLOBAL" file contains the list of global variables and functions used by all the scripts

##Driver script

Run the following command inside the source file directory

`sudo ./driver.sh`

You can select the tools you want to install by making a check in the dialog.

###1. Gearman Server
  1. Download and compile Gearman source code.

###2. Gearman Manager
  1.  Download Gearman Manager source code
  2.  Install PHP gearman libraries
  3.  Compile pcntl extension for PHP

###3. Gearman UI
  1. Gearman UI source code written in PHP
  2. Download and install Node Package Manager(npm)
  3. Download and install Bower
  4. Install Composer for PHP

##Individual files can also be run in the following manner

`sudo ./install_php.sh` will compile and install php alongwith pear, pcntl and mysql extensions as per GLOBAL

`sudo ./install_gearman.sh` will install gearman version as mentioned in GLOBAL

`sudo ./install_gearman_manager.sh` will install [Gearman manager](https://github.com/brianlmoon/GearmanManager) based on PHP version present

`sudo ./install_gearman_ui.sh` will install [gearman web ui](http://gaspaio.github.io/gearmanui/)

##Post Installation

###1. Gearman Server

###2. Gearman Manager
1. Copy pcntl.so and gearman.so in php.ini file

###3. Gearmanui
1. You need to copy gearmanui folder downloaded in `GEARMAN_UI_DIR` in `GLOBAL` file to the document root of your web server. Also the document root should point to `gearmanui/web`
2. Make sure appropriate php version is enabled in your web server conf file
3. In case of Apache server, set `AllowOverride All` in httpd.conf file. 

##Using Gearman and other tools

###1. Gearman Server
1. Start the gearmand daemon  by running `sudo service gearmand start`. 
2. This will start the daemon on port number 4730 by default
3. You can verify by `telnet 127.0.0.1 4730`.

###2. Gearman Manager
1. Start the gearman manager daemon  by running `sudo service gearman-manager start`.
2. By default, it will launch 3 workers for each of the functions `fetch_url` and `reverse_string`. These workers are located in `${GEARMAN_MANAGER_DOWNLOAD_DIR}`/GearmanManager/lib/pecl-workers as specified in GLOBAL
3. The conf file for gearman manager is located in `GEARMAN_MANAGER_CONF` in GLOBAL
4. You can check if the workers are launched by the following command

`telnet 127.0.0.1 4730`
Once you are connected run `status` command. The output should be following:
```
status
reverse_string	0	0	3
fetch_url	    0	0	3
```
The same can also be seen through gearmanui

###3. Gearman UI
1. Once, you have followed the post installation steps, check the config file in `${GEARMAN_UI_DIR}`/gearmanui/config.yml. By default the UI points to gearman server on localhost. 
2. Once you hit the url in the browser, you should be able to see the same thing as the telnet interface.

##ToDo

2. Replace yum update with only the needed packages.
