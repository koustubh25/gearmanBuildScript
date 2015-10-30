#!/bin/bash

read "This script will now install 
  Gearman. Press any key to conitnue"
./install_gearman.sh


read "This script will now install 
  Gearman Manager. Press any key to conitnue"
./install_gearmanmanager.sh

read "This script will now install 
  Gearman web ui. Press any key to conitnue"
./install_geramanui.sh

echo "Driver script has now ended."
