#!/bin/bash
#
# Run this script with sudo -E, otherwise $HOME points to /root instead of /home/username
# After running this script a new env variable $USERHOME is available for sudo to use instead of -E
#
# Create a system-wide environmental variable that will always point to the home folder of the logged in user
# Useful since Ubuntu 19.10 to have an env when using sudo that points to /home/username instead of /root.
sh -c "echo USERHOME=/home/$SUDO_USER >> /etc/environment"
#
#________________________________
# Budgie Desktop Settings
# -------------------------------
# Dark mode
gsettings set com.solus-project.budgie-panel dark-theme true
#
# Theme with clearer icons
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'
#
# close/minimise/maximise buttons on the left side (more common)
gsettings set com.solus-project.budgie-wm button-style 'left'
#
# Panel left side, size 53 (=treshold for bigger app icons)
#
# folders always list view instead of big icon view
gsettings set org.nemo.preferences default-folder-viewer 'list-view'
#
# disable doubleclick empty area to go up 1 folder
gsettings set org.nemo.preferences click-double-parent-folder false
#
# week numbers in Raven calendar
gsettings set com.solus-project.budgie-raven enable-week-numbers true
#
# show reload folder button
gsettings set org.nemo.preferences show-reload-icon-toolbar true
#
# get brightness, volume etc buttons on laptop keyboard to work
gsettings set org.onboard layout '/usr/share/onboard/layouts/Full Keyboard.onboard'

#________________________________
# AppImageLauncher - integrate AppImage apps on first execution
# -------------------------------
sudo add-apt-repository ppa:appimagelauncher-team/stable -y
sudo apt -y update
sudo apt -y install appimagelauncher


#________________________________
# MS Office fonts
# -------------------------------
wget --no-check-certificate https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/officefonts.sh
sudo bash officefonts.sh
wait
rm officefonts.sh
#________________________________
# LibreOffice Dutch UI/Spellcheck/Hyphencheck/Help
# -------------------------------
sudo apt-add-repository ppa:libreoffice/ppa -y
sudo apt -y update
sudo apt-get -y install libreoffice-l10n-nl hunspell-nl hyphen-nl libreoffice-help-nl


#_________________________________
# Add repository for recommended Budgie stuff
# --------------------------------
sudo add-apt-repository ppa:ubuntubudgie/backports -y
sudo add-apt-repository ppa:linrunner/tlp -y
sudo apt -y update
sudo apt-get -y install lm-sensors
sudo apt -y install tlp
sudo apt -y install hardinfo

#_________________________________
# Install applets required for Panel
# --------------------------------
sudo apt -y install budgie-kangaroo-applet
sudo apt -y install budgie-workspace-wallpaper-applet
sudo apt -y install budgie-calendar-applet
#_________________________________
# Get separators for Plank or Dock
# --------------------------------
# Get a seperator-like app icon
sudo wget --no-check-certificate -P /usr/share/icons https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/separators/separatorH.svg
# Get a seperator-like app shortcut
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/separators/SeparatorH1.desktop
#_________________________________
# Apply panel layout
# --------------------------------
sudo wget --no-check-certificate -P /usr/share/budgie-desktop/layouts https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/widescreen.layout


#______________________________________
# Get a Firefox shortcut for 2 profiles
# -------------------------------------
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/firefox.desktop


#________________________________
# Timeshift - automated system snapshots (backups) 
# -------------------------------
sudo add-apt-repository -y ppa:teejee2008/timeshift
sudo apt -y update
sudo apt-get -y install timeshift
#________________________________
# Pluma - better simple notepad 
# -------------------------------
sudo apt-get -y install pluma
#________________________________
# VLC - better videoplayer
# -------------------------------
sudo apt-get -y install vlc
#________________________________
# Recommended apps to install manually
# -------------------------------
echo -e "\n\nPlease install the following recommended apps by downloading them manually:\n"
echo -e "BLEACHBIT (cleanup) \t https://www.bleachbit.org/download/linux"
echo -e "NOMACHINE (share desktop within local network) \t https://www.nomachine.com/download/download&id=4"
echo -e "ANYDESK (remote desktop via internet) \t https://anydesk.com/en/downloads/linux"
echo -e "DIGIKAM (photo management) \t https://www.digikam.org/download/"
echo -e "RAWTHERAPEE ART (raw photo editor) \t https://bitbucket.org/agriggio/art/downloads/"
