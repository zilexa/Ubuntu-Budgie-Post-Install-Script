#!/bin/bash
#
#_________________________________
# Get separators for Plank or Dock
# --------------------------------
# Get a seperator-like app icon
sudo wget --no-check-certificate -P /usr/share/icons https://github.com/zilexa/UB-PostInstall/blob/master/separators/separatorH.svg
# Get a seperator-like app shortcut
wget --no-check-certificate -P /home/$USERDIR/.local/share/applications https://raw.githubusercontent.com/zilexa/UB-PostInstall/master/separators/SeparatorH1.desktop
#
#______________________________________
# Get a Firefox shortcut for 2 profiles
# -------------------------------------
wget --no-check-certificate -P /home/$USERDIR/.local/share/applications https://raw.githubusercontent.com/zilexa/UB-PostInstall/master/firefox.desktop
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
#
#________________________________
# MS Office fonts
# -------------------------------
wget --no-check-certificate https://raw.githubusercontent.com/zilexa/Mediaserver/master/officefonts.sh
sudo bash officefonts.sh
wait
rm officefonts.sh
exit 0

