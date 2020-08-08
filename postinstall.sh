#!/bin/bash
#
# Welcome to Ubuntu Budgie! An intuitive, user friendly, light and fast Operating System. 
# For most people, it is better than Windows (10) or MacOS. It can easily look exactly like Windows or Mac.
# However that is not the goal of this script. This script will add features that will be standard features of upcoming releases. 
# Like gestures, folder colors and some nice applets. 
# It will also apply settings to make it feel more intuitive, settings that can easily be changed/reverted by the user. 

# Create a system-wide environmental variable that will always point to the home folder of the logged in user
# Useful since Ubuntu 19.10. Now when you use sudo, this custom env-variable points to /home/username instead of /root.
sudo sh -c "echo USERHOME=/home/$LOGNAME >> /etc/environment"

#___________________________________
# Budgie Desktop Extras & Essentials
# ----------------------------------
# Add repository for recommended Budgie stuff
sudo add-apt-repository -y ppa:ubuntubudgie/backports
sudo add-apt-repository -y ppa:costales/folder-color
sudo add-apt-repository -y ppa:teejee2008/timeshift
sudo add-apt-repository -y ppa:appimagelauncher-team/stable
sudo add-apt-repository -y ppa:linrunner/tlp
sudo apt -y update

# Install common applets required for Widescreen Panel Layout
sudo apt -y install budgie-kangaroo-applet
sudo apt -y install budgie-workspace-wallpaper-applet
sudo apt -y install budgie-calendar-applet
sudo apt -y install budgie-previews

# Allow Folder Colors
sudo apt -y install folder-color-nemo
nemo -q

# enable system sensors read-out like temperature, fan speed
sudo apt -y install lm-sensors

# install tlp to control performance and temperature automatically
sudo apt -y install tlp tlp-rdw
sudo tlp start

# Timeshift - automated system snapshots (backups) 
sudo apt -y install timeshift

# Integrate AppImages at first launch
sudo apt -y install appimagelauncher

#______________________________________________
# Configure Widescreen Panel and get seperators
# ---------------------------------------------
# Apply a much better icon for the LibreOffice StartCenter (by default it is plain white textfile icon)
sudo sed -i -e 's/Icon=libreoffice-startcenter/Icon=libreoffice-oasis-text-template/g' /usr/share/applications/libreoffice-startcenter.desktop
cp /usr/share/applications/libreoffice-startcenter.desktop $HOME/.local/share/applications
# replace override file otherwise some settings will be reverted back after reset and only default icons will be pinned
sudo wget --no-check-certificate -O /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/25_budgie-desktop-environment.gschema.override
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
# Get a horizontal seperator-like app icon
sudo wget --no-check-certificate -P /usr/share/icons https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/separators/separatorH.svg
# Get a seperator-like app shortcut
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/separators/SeparatorH1.desktop
# Switch to widescreen panel layout with medium sized icons
sudo wget --no-check-certificate -P /usr/share/budgie-desktop/layouts https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/widescreen.layout
gsettings set com.solus-project.budgie-panel layout 'widescreen'
# reset panel to apply changes
nohup budgie-panel --reset --replace &
# disable plank from autostarting
rm -r /home/$LOGNAME/.config/autostart/plank.desktop
# stop plank
sudo pkill plank

#____________________________
# Budgie Desktop basic config
# ---------------------------
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

# allow slow doubleclick on filename to rename file
gsetting set org.nemo.preferences.quick-renames-with-pause-in-between true
sudo gsetting set org.nemo.preferences.quick-renames-with-pause-in-between true

# show reload folder button
gsettings set org.nemo.preferences show-reload-icon-toolbar true
sudo gsettings set org.nemo.preferences show-reload-icon-toolbar true

# week numbers in Raven calendar
gsettings set com.solus-project.budgie-raven enable-week-numbers true

# get brightness, volume etc buttons on every laptop keyboard to work
gsettings set org.onboard layout '/usr/share/onboard/layouts/Full Keyboard.onboard'

# Enable Window Previews for alt-tab
gsettings set org.ubuntubudgie.budgie-wpreviews allworkspaces true
gsettings set org.ubuntubudgie.budgie-wpreviews enable-previews true

# Change QuickNote path to /Documents
gsettings set org.ubuntubudgie.plugins.quicknote custompath "$HOME/Documents"

# Notifications Top-Left to match Panel on leftside
gsettings set com.solus-project.budgie-panel notification-position 'BUDGIE_NOTIFICATION_POSITION_TOP_LEFT'

# Touchpad should match scroll direction of mouse (default of mouse is non-natural)
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Show battery percentage in taskbar
gsettings set org.gnome.desktop.interface.show-battery-percentage true

# Enable auto night light
gsettings set org.gnome.settings-daemon.plugins.color.night-light-enabled true

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

#______________________________
# Allow 3 and 4 finger gestures
# -----------------------------
sudo gpasswd -a $USER input
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
#rm -r gestures-master
wget -O $HOME/.config/libinput-gestures.conf https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/libinput-gestures.conf
libinput-gestures-setup stop
libinput-gestures-setup start
cd $HOME

#________________________
# Make LibreOffice usable
# -----------------------
# (DONE during Widescreen layout config) Apply a much better icon for the LibreOffice StartCenter (by default it is plain white textfile icon)
# sudo sed -i -e 's/Icon=libreoffice-startcenter/Icon=libreoffice-oasis-text-template/g' /usr/share/applications/libreoffice-startcenter.desktop
# cp /usr/share/applications/libreoffice-startcenter.desktop $HOME/.local/share/applications

# Install ALL common Microsoft Office fonts
wget --no-check-certificate https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/officefonts.sh
sudo bash officefonts.sh
rm officefonts.sh


#____________________________
# Install essential software 
# ---------------------------
# Pluma - better simple notepad 
sudo apt -y install pluma
# Pluma enable line numbers, highlight current line and show bracket matching. 
gsettings set org.mate.pluma.display-line-numbers true
gsettings set org.mate.pluma.highlight-current-line true
gsettings set org.mate.pluma.bracket-matching true
sudo gsettings set org.mate.pluma.display-line-numbers true
sudo gsettings set org.mate.pluma.highlight-current-line true
sudo gsettings set org.mate.pluma.bracket-matching true

# Bleachbit - system cleanup
wget https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1910.deb
sudo apt -y install ./bleachbit*.deb

# Add repositories for applications that have their own up-to-date repository
# ---------------------------
# Add Pinta repository
sudo add-apt-repository -y ppa:pinta-maintainers/pinta-stable
# Add Anydesk repository
echo 'deb http://deb.anydesk.com/ all main' | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
# Add Darktable repository
echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/graphics:darktable.list
wget -qO - https://download.opensuse.org/repositories/graphics:darktable/xUbuntu_20.04/Release.key | sudo apt-key add -
# Reload repositories
sudo apt -y update

# Now install applications from added repositories
# ---------------------------
# Pinta - Alternative to Drawing (like Ms Paint) 
sudo apt -y install pinta 
# Install AnyDesk (remote support)
sudo apt -y install anydesk
sudo systemctl disable anydesk
# DarkTable - image editing
sudo apt -y install darktable

# set app defaults (solves known Ubuntu Budgie issues)
# ---------------------------
sudo wget -O /usr/share/applications/defaults.list https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/defaults.list


#______________________________________
#             OPTIONAL 
# -------------------------------------
# Get LibreOffice Dutch UI/Spellcheck/Hyphencheck/Help
read -p "Install Dutch languagepack for LibreOffice (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        sudo apt-add-repository ppa:libreoffice/ppa -y
        sudo apt -y update
        sudo apt -y install libreoffice-l10n-nl hunspell-nl hyphen-nl libreoffice-help-nl
    ;;
    * )
        echo "Skipping Dutch languagepack for LibreOffice..." 
    ;;
esac

# Install Spotify
read -p "Install Spotify (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo Installing Spotify by adding its repository...
        wget -qO - https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt -y update && sudo apt -y install spotify-client
    ;;
    * )
        echo "Skipping Spotify..." 
    ;;
esac

# Install Deadbeef or Audacious musicplayer
echo "Replace the local music player (Rhytmbox) with one that supports folders in a tree-view?"
read -p "Recommended if you have custom music, your own recordings or music without proper tags (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo "Replacing Rhythmbox for Deadbeef and applying Zilexa config & layout"
        # Removing Rhythmbox
        sudo apt -y autoremove rhythmbox --purge
        # Installing Deadbeef
        wget https://downloads.sourceforge.net/project/deadbeef/travis/linux/1.8.4/deadbeef-static_1.8.4-1_amd64.deb
        sudo apt -y install ./deadbeef*.deb
        # Get config file and required pre-build plugins for layout
        wget https://github.com/zilexa/deadbeef-config-layout/archive/master.zip
        unzip master.zip
        mv deadbeef-config-layout-master/lib $HOME/.local/
        mkdir $HOME/.config/deadbeef/
        mv deadbeef-config-layout-master/config $HOME/.config/deadbeef/
        rm -r deadbeef-config-layout-master
        rm master.zip
    ;;
    * )
        echo "Installing Audacious instead of Deadbeef and removing Rhythmbox" 
        # Removing Rhythmbox
        sudo apt -y autoremove rhythmbox --purge
        # Installing Audacious
        sudo add-apt-repository -y ppa:ubuntuhandbook1/apps
        sudo apt -y update
        sudo apt -y install audacious
        # set Audacious as default player
        sudo sed -i -e 's/deadbeef/audacious/g' /usr/share/applications/defaults.list
        
    ;;
esac

# Get a Firefox shortcut for 2 profiles
echo "If you share this laptop, you can right-click Firefox to select which Firefox profile to launch."
read -p "Only useful if each user has its own Firefox profile. Do you need this option (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo adding profiles to right-click of Firefox shortcut... 
        wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/firefox.desktop
    ;;
    * )
        echo "Keeping the Firefox shortcut as is..."
    ;;
esac

# DigiKam
echo "install the photo management tool (DigiKam), recommeded for large photo collections (Y/n)?"
read -p "(The downloadpage will open in your browser. choose the Linux 64-bit AppImage.)" answer
case ${answer:0:1} in
    y|Y )
       xdg-open https://www.digikam.org/download/
    ;;
    * )
        echo "Skipping DigiKam..."
    ;;
esac

# RawTherapee
echo "DarkTable is a (raw) photo editor and has been installed already. Would you also like to install RawTherapee ART (Y/n)?"
read -p "(The downloadpage will open.)" answer
case ${answer:0:1} in
    y|Y )
       xdg-open https://bitbucket.org/agriggio/art/downloads/
    ;;
    * )
        echo "Skipping RawTherapee..."
    ;;
esac

# NoMachine
echo "AnyDesk has been installed already for remote desktop sharing. Would you also like to install NoMachine (Y/n)?"
read -p "Recommended to share desktop within your network. to access a PC while on your laptop for example (the downloadpage will open)." answer
case ${answer:0:1} in
    y|Y )
       xdg-open https://www.nomachine.com/download/download&id=4
    ;;
    * )
        echo "Skipping NoMachine..."
    ;;
esac

echo "DONE! please REBOOT now, type sudo reboot now and hit enter."
