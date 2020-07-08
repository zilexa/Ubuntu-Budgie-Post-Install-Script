#!/bin/bash

# Installs Brother MFC-L2750DW 32-bit drivers on 64-bit Ubuntu 19.10 or higher.
# Brother only provides 32-bit drivers and has removed the required instructions for 64-bit OS. 

sudo ufw allow 54925/udp
sudo ufw allow 54921/tcp
sudo apt --yes install lib32z1 libncurses5:i386 lib32stdc++6 gcc-4.8-base:i386 libgcc1:i386 libc6:i386
echo "deb http://nl.archive.ubuntu.com/ubuntu bionic-updates main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install lib32ncurses5
wget --no-check-certificate https://download.brother.com/welcome/dlf103530/mfcl2750dwpdrv-4.0.0-1.i386.deb
dpkg  -i fcl2750dwpdrv-4.0.0-1.i386.deb
rm fcl2750dwpdrv-4.0.0-1.i386.deb
sudo sh -c "echo listen $SERVERIP:631 >> /etc/cups/cupsd.conf"
sudo sh -c "echo ServerAdmin $EMAIL >> /etc/cups/cupsd.conf"
