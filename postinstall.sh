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
sudo gsettings set com.solus-project.budgie-panel dark-theme true

# Theme with clearer icons
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'
sudo gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'

# close/minimise/maximise buttons on the left side (more common)
gsettings set com.solus-project.budgie-wm button-style 'left'
sudo gsettings set com.solus-project.budgie-wm button-style 'left'

# folders always list view instead of big icon view
gsettings set org.nemo.preferences default-folder-viewer 'list-view'
sudo gsettings set org.nemo.preferences default-folder-viewer 'list-view'

# disable doubleclick empty area to go up 1 folder
gsettings set org.nemo.preferences click-double-parent-folder false
sudo gsettings set org.nemo.preferences click-double-parent-folder false

# week numbers in Raven calendar
gsettings set com.solus-project.budgie-raven enable-week-numbers true

# show reload folder button
gsettings set org.nemo.preferences show-reload-icon-toolbar true
sudo gsettings set org.nemo.preferences show-reload-icon-toolbar true

# get brightness, volume etc buttons on laptop keyboard to work
gsettings set org.onboard layout '/usr/share/onboard/layouts/Full Keyboard.onboard'

# Enable Window Previews for alt-tab
gsettings set org.ubuntubudgie.budgie-wpreviews allworkspaces true
gsettings set org.ubuntubudgie.budgie-wpreviews enable-previews true

#Change QuickNote path to /Documents
gsettings set org.ubuntubudgie.plugins.quicknote custompath "$HOME/Documents"

# Print Scr should take area screenshot
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip '@as []'
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip '@as []'
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip '@as []'
gsettings set org.gnome.settings-daemon.plugins.media-keys screencast '@as []'
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot '@as []'
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '@as []'
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '@as []'
gsettings set com.solus-project.budgie-wm take-region-screenshot "['Print']"
gsettings set com.solus-project.budgie-wm take-full-screenshot "['<Ctrl>Print']"
mkdir $HOME/Pictures/Screenshots
gsettings set org.gnome.gnome-screenshot auto-save-directory "$HOME/Pictures/Screenshots"

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
# Switch to widescreen panel layout with medium sized icons
# --------------------------------
sudo wget --no-check-certificate -P /usr/share/budgie-desktop/layouts https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/widescreen.layout

#_________________________________
# Allow 3 and 4 finger gestures
# --------------------------------
sudo apt -y install libinput-tools
cd $HOME/Downloads
wget https://github.com/bulletmark/libinput-gestures/archive/master.zip
unzip master.zip
cd libinput-gestures-master
sudo ./libinput-gestures-setup install
cd ..
rm -r master.zip
rm -r libinput-gestures-master
libinput-gestures-setup autostart
libinput-gestures-setup start
wget https://gitlab.com/cunidev/gestures/-/archive/master/gestures-master.zip
unzip gestures-master.zip
cd gestures-master
sudo apt -y install python3-setuptools
sudo python3 setup.py install
cd ..
rm -r gestures-master.zip
rm -r gestures-master
wget -P $HOME/.config https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/libinput-gestures.conf
cd $HOME


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


#________________________________
# Folder Color for Nemo file manager 
# -------------------------------
sudo add-apt-repository ppa:costales/folder-color
sudo apt-get update
sudo apt-get install folder-color-nemo
nemo -q
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
#______________________________________
# Install DarkTable
# -------------------------------------
echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/graphics:darktable.list
curl -fsSL https://download.opensuse.org/repositories/graphics:darktable/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/graphics:darktable.gpg > /dev/null
sudo apt update
sudo apt -y install darktable
#______________________________________
# Install AnyDesk (remote support)
# -------------------------------------
# wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
#sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
#sudo apt -y update
#sudo apt-get -y install anydesk
#______________________________________
# Get a Firefox shortcut for 2 profiles
# -------------------------------------
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/myconfig-ubuntu/master/firefox.desktop
#________________________________
# Recommended apps to install manually
# -------------------------------
echo -e "\n\nPlease install the following recommended apps by downloading them manually:\n"
echo -e "BLEACHBIT (cleanup) \t https://www.bleachbit.org/download/linux"
echo -e "NOMACHINE (share desktop within local network) \t https://www.nomachine.com/download/download&id=4"
echo -e "ANYDESK (remote desktop via internet) \t https://anydesk.com/en/downloads/linux"
echo -e "DIGIKAM (photo management) \t https://www.digikam.org/download/"
echo -e "RAWTHERAPEE ART (raw photo editor) \t https://bitbucket.org/agriggio/art/downloads/"
