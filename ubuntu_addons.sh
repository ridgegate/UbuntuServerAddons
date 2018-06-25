#!/bin/bash
# This script install the following packages
#   1. xRDP, xfce4 interface for windows remote desktop connections
#   2. Fsearch for quick file search like Everything from Voidtools for Windows
#   3. Syncthing for file synchronization on your own computers without cloud services 
#      (similar to Dropbox but requires computesr to be always on)
#   4. Chrome for accessing Syncthing WebGUI without allowing anyone to connect even from WWW
#   5. Samba for windows file sharing
#
# sources:
# https://www.tweaking4all.com/software/linux-software/use-xrdp-remote-access-ubuntu-14-04/
# https://github.com/cboxdoerfer/fsearch
# https://apt.syncthing.net/

# --------Add all the repositories-------
#FSearch Repository
sudo add-apt-repository -y ppa:christian-boxdoerfer/fsearch-daily
#Syncthing Repository
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
#Chrome Repository
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update -y

clear 
echo "Please provide your username"
read -p "Type your user name, then press [ENTER] : " MY_USER_NAME
echo "Please provide your password"
read -p "Type your password, then press [ENTER] : " MY_PWD
echo "installing the required packages"

# -------Install xRDP and xfce4-------
sudo apt-get install -y xrdp
sudo apt-get install -y xfce4

# Modify two files to make sure xRDP uses Xfce4
# This auto backup and overwrite the startwm.sh file in /etc/xrdp/ directory.
echo xfce4-session > ~/.xsession
cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh_backup 
wget -q https://raw.githubusercontent.com/ridgegate/xRDP-on-Ubuntu/master/startwm.sh -O /etc/xrdp/startwm.sh 

sudo service xrdp restart
# -------End of Install xRDP and xfce4-------

# -------Install Syncthing-------
sudo apt-get install -y syncthing

#Autostart Syncthing as systemd service
sudo wget -q https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-systemd/system/syncthing%40.service /etc/systemd/system/syncthing%40.service
# Might need to enter password -- Could use expect to automate the process.
systemctl enable syncthing@$MY_USER_NAME.service
systemctl start syncthing@$MY_USER_NAME.service
# -------End of Install Syncthing-------

# ------- Install Samba-------
sudo apt-get install -y samba smbclient
sudo smbpasswd -a $MY_USER_NAME
expect \"New SMB password:\"
send \"$MY_PWD\r\"
expect \"Retype new SMB password:\"
send \"$MY_PWD\r\"
# -------End of Install Samba-------

# Install fsearch
sudo apt install -y fsearch-trunk
# Install Chrome
sudo apt-get install -y google-chrome-stable
# Install General Purporse Mouse
sudo apt-get install -y gpm
# Install LibreOffice
sudo apt-get install -y libreoffice

echo "Edit your /etc/samba/smb.conf file to allow access to the appropriate folders/files"
echo "Format to follow:"
echo "    [<folder_name>]"
echo "    path = <path>/<folder_name>"
echo "    valid users = <user_name>"
echo "    read only = no"
echo "    browsable = yes"
echo
echo "Once smb.conf file has been edited and saved. Restart SAMBA service with the following command"
ehco "sudo service smbd restart"
echo
echo
echo "All done and Enjoy!"
