#!/bin/bash
# This script install the following packages
#   1. xRDP, xfce4 interface for windows remote desktop connections
#   2. Fsearch for quick file search like Everything from Voidtools for Windows
#
# sources:
# https://www.tweaking4all.com/software/linux-software/use-xrdp-remote-access-ubuntu-14-04/
# https://github.com/cboxdoerfer/fsearch

clear 
# Installing first step
echo "installing the required packages"
sudo apt-get update
sudo apt-get install xrdp
sudo apt-get install xfce4

# Modify two files to make sure xRDP uses Xfce4
# This auto backup and overwrite the startwm.sh file in /etc/xrdp/ directory.
echo xfce4-session > ~/.xsession
cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh_backup 
wget -q https://raw.githubusercontent.com/ridgegate/xRDP-on-Ubuntu/master/startwm.sh -O /etc/xrdp/startwm.sh 

sudo service xrdp restart

#install the second step: fsearch
sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-daily
sudo apt-get update
sudo apt install fsearch-trunk
