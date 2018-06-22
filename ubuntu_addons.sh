#!/bin/bash
# This script install the following packages
#   1. xRDP, xfce4 interface for windows remote desktop connections
#   2. Fsearch for quick file search like Everything from Voidtools for Windows
#   3. Syncthing for file synchronization on your own computers without cloud services 
#      (similar to Dropbox but requires computesr to be always on)
#
# sources:
# https://www.tweaking4all.com/software/linux-software/use-xrdp-remote-access-ubuntu-14-04/
# https://github.com/cboxdoerfer/fsearch
# https://apt.syncthing.net/

clear 
# -------Install xRDP and xfce4-------
echo "installing the required packages"
sudo apt-get update -y
sudo apt-get install -y xrdp
sudo apt-get install -y xfce4

# Modify two files to make sure xRDP uses Xfce4
# This auto backup and overwrite the startwm.sh file in /etc/xrdp/ directory.
echo xfce4-session > ~/.xsession
cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh_backup 
wget -q https://raw.githubusercontent.com/ridgegate/xRDP-on-Ubuntu/master/startwm.sh -O /etc/xrdp/startwm.sh 

sudo service xrdp restart
# -------End of Install xRDP and xfce4-------

# -------Install fsearch-------
sudo add-apt-repository -y ppa:christian-boxdoerfer/fsearch-daily
sudo apt-get update -y
sudo apt install -y fsearch-trunk
# -------End of Install fsearch-------

# -------Install Syncthing-------
# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
# Update and install syncthing:
sudo apt-get update -y
sudo apt-get install -y syncthing
# -------End of Install Syncthing-------

# -------Install Chrome-------
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update -y
sudo apt-get install -y google-chrome-stable
# -------End of Install Chrome-------
