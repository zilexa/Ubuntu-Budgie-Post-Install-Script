#!/bin/bash
#
# Welcome to Ubuntu Budgie! An intuitive, user friendly, light and fast Operating System. 
# For most people, it is better than Windows (10) or MacOS. It can easily look exactly like Windows or Mac.
# However that is not the goal of this script. This script will add features that will be standard features of upcoming releases. 
# Like gestures, folder colors and some nice applets. 
# It will also apply settings to make it feel more intuitive, settings that can easily be changed/reverted by the user. 

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

# Timeshift - automated system snapshots (backups) and set configuration
sudo apt -y install timeshift
sudo wget -O /etc/timeshift/timeshift.json https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/timeshift/timeshift.json
sudo sed -i -e 's#asterix#'"$LOGNAME"'#g' /etc/timeshift/timeshift.json

# Integrate AppImages at first launch
sudo apt -y install appimagelauncher

# Install ExFat support
sudo apt -y install exfat-utils

#______________________________________________
# Configure Widescreen Panel and get seperators
# ---------------------------------------------
# Apply a much better icon for the LibreOffice StartCenter (by default it is plain white textfile icon)
sudo sed -i -e 's/Icon=libreoffice-startcenter/Icon=libreoffice-oasis-text-template/g' /usr/share/applications/libreoffice-startcenter.desktop
cp /usr/share/applications/libreoffice-startcenter.desktop $HOME/.local/share/applications
# replace override file otherwise some settings will be reverted back after reset and only default icons will be pinned
sudo wget --no-check-certificate -O /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/25_budgie-desktop-environment.gschema.override
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
# Get a horizontal seperator-like app icon
sudo wget --no-check-certificate -P /usr/share/icons https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/separators/separatorH.svg
# Get a seperator-like app shortcut
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/separators/SeparatorH1.desktop
# Switch to widescreen panel layout with medium sized icons
sudo wget --no-check-certificate -P /usr/share/budgie-desktop/layouts https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/widescreen.layout
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

# DEFAULT SINCE 20.10 disable doubleclick empty area to go up 1 folder
# gsettings set org.nemo.preferences click-double-parent-folder false
#sudo gsettings set org.nemo.preferences click-double-parent-folder false

# DEFAULT SINCE 20.10 allow slow doubleclick on filename to rename file
#gsettings set org.nemo.preferences quick-renames-with-pause-in-between true
#sudo gsettings set org.nemo.preferences quick-renames-with-pause-in-between true

# show reload folder button
gsettings set org.nemo.preferences show-reload-icon-toolbar true
sudo gsettings set org.nemo.preferences show-reload-icon-toolbar true

# DEFAULT SINCE 20.10 week numbers in Raven calendar
# gsettings set com.solus-project.budgie-raven enable-week-numbers true

# get brightness, volume etc buttons on every laptop keyboard to work
gsettings set org.onboard layout '/usr/share/onboard/layouts/Full Keyboard.onboard'

# Enable Window Previews for alt-tab
gsettings set org.ubuntubudgie.budgie-wpreviews allworkspaces true
gsettings set org.ubuntubudgie.budgie-wpreviews enable-previews true

# ? Change QuickNote path to /Documents
# gsettings set org.ubuntubudgie.plugins.quicknote custompath "$HOME/Documents"

# Notifications Top-Left to match Panel on leftside
gsettings set com.solus-project.budgie-panel notification-position 'BUDGIE_NOTIFICATION_POSITION_TOP_LEFT'

# Touchpad should match scroll direction of mouse (default of mouse is non-natural)
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Show battery percentage in taskbar
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Enable auto night light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# Print Scr should take area screenshot
#gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip '@as []'
#gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip '@as []'
#gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip '@as []'
#gsettings set org.gnome.settings-daemon.plugins.media-keys screencast '@as []'
#gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot '@as []'
#gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '@as []'
#gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '@as []'
#gsettings set com.solus-project.budgie-wm take-region-screenshot "['Print']"
#gsettings set com.solus-project.budgie-wm take-full-screenshot "['<Ctrl>Print']"
#mkdir $HOME/Pictures/Screenshots
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
# Get the preconfigured file enabling 3/4 finger up/down swipe to show/hide open windows (alt+tab) and 2 finger left/right for prev/next page.
# This is the default file untouched only copied those 4 gestures, added the correct command for Budgie and commented out the original. 
wget -O $HOME/.config/libinput-gestures.conf https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/libinput-gestures.conf
libinput-gestures-setup stop
libinput-gestures-setup start
libinput-gestures-setup autostart
libinput-gestures-setup start
# Experimental UI for libinput gestures, not installed because untested and does not reflect the configured gestures from libinput-gestures.
#wget https://gitlab.com/cunidev/gestures/-/archive/master/gestures-master.zip
#unzip gestures-master.zip
#cd gestures-master
#sudo apt -y install python3-setuptools
#sudo python3 setup.py install
#cd ..
#rm -r gestures-master.zip
#rm -r gestures-master
cd $HOME/Downloads

#________________________
# Make LibreOffice usable
# -----------------------
# (DONE during Widescreen layout config) Apply a much better icon for the LibreOffice StartCenter (by default it is plain white textfile icon)
# sudo sed -i -e 's/Icon=libreoffice-startcenter/Icon=libreoffice-oasis-text-template/g' /usr/share/applications/libreoffice-startcenter.desktop
# cp /usr/share/applications/libreoffice-startcenter.desktop $HOME/.local/share/applications

# Install ALL common Microsoft Office fonts
wget --no-check-certificate https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/libreoffice/officefonts.sh
sudo bash officefonts.sh
rm officefonts.sh


#____________________________
# Install essential software 
# ---------------------------
# Pluma - better simple notepad 
sudo apt -y install pluma
# Pluma enable line numbers, highlight current line and show bracket matching. 
gsettings set org.mate.pluma display-line-numbers true
gsettings set org.mate.pluma highlight-current-line true
gsettings set org.mate.pluma bracket-matching true
gsettings set org.mate.pluma color-scheme 'cobalt'
sudo gsettings set org.mate.pluma display-line-numbers true
sudo gsettings set org.mate.pluma highlight-current-line true
sudo gsettings set org.mate.pluma bracket-matching true
sudo gsettings set org.mate.pluma color-scheme 'cobalt'

# Audacity - Audio recording and editing
sudo apt -y install audacity

# Bleachbit - system cleanup
wget https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1910.deb
sudo apt -y install ./bleachbit*.deb
sudo wget -O /root/.config/bleachbit/bleachbit.ini https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/bleachbit/bleachbit.ini


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
# Add Syncthing repository
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing
# Add OnlyOffice repository
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
sudo add-apt-repository "deb https://download.onlyoffice.com/repo/debian squeeze main"
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
sudo apt-get install onlyoffice-desktopeditors
# Syncthing - sync folders between devices
sudo apt -y install syncthing
sudo wget -O /etc/systemd/system/syncthing@.service https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/syncthing/syncthing%40.service
# OnlyOffice - Better alternative for existing MS Office files
sudo apt -y install onlyoffice-desktopeditors

# NFS - Fastest way to access shared folders over the network (as a client) - just replace "X" in the example added to /etc/fstab
sudo apt -y install nfs-common
echo "#192.168.88.X:  /mnt/X  nfs4  nfsvers=4,minorversion=2,proto=tcp,fsc,nocto  0  0" | sudo tee -a /etc/fstab

# Set app defaults (solves known Ubuntu Budgie issues)
# ---------------------------
sudo wget -O /usr/share/applications/defaults.list https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/defaults.list


# Also rename Pictures to Photos and Videos to Media 
mv /$HOME/Pictures /$HOME/Photos
mv /$HOME/Videos /$HOME/Media
# Move /Desktop and /Templates to be subfolders of /Documents
# This makes it easy for syncing with my server or the cloud
mv /$HOME/Templates /$HOME/Documents/
mv /$HOME/Desktop /$HOME/Documents/
sudo sed -i -e 's+$HOME/Desktop+$HOME/Documents/Desktop+g' $HOME/.config/user-dirs.dirs
sudo sed -i -e 's+$HOME/Templates+$HOME/Documents/Templates+g' $HOME/.config/user-dirs.dirs
# Remove the $HOME/Public folder and prevent it from being created at boot
rm -rf $HOME/Public
sudo sed -i -e 's+$HOME/Public+$HOME+g' $HOME/.config/user-dirs.dirs


#______________________________________
#             OPTIONAL 
# -------------------------------------
# DEFAULT SINCE 20.10 Get LibreOffice Dutch UI/Spellcheck/Hyphencheck/Help
#read -p "Install Dutch languagepack for LibreOffice (y/n)?" answer
#case ${answer:0:1} in
#    y|Y )
#        sudo apt-add-repository ppa:libreoffice/ppa -y
#        sudo apt -y update
#        sudo apt -y install libreoffice-l10n-nl hunspell-nl hyphen-nl libreoffice-help-nl
#    ;;
#    * )
#        echo "Skipping Dutch languagepack for LibreOffice..." 
#    ;;
#esac

# KeepassXC
echo "Install KeepassXC?? (Y/n)"
read -p "The only free, FOSS, password manager that provides maximum security and can be synced between devices" answer
case ${answer:0:1} in
    y|Y )
       sudo add-apt-repository ppa:phoerious/keepassxc
       sudo apt update && sudo apt -y install keepassxc
    ;;
    * )
        echo "Not enabling Syncthing..."
    ;;
esac

# Install Deadbeef or Audacious musicplayer
echo "Do you need a musicplayer that supports folder-view? (Y/n)"
read -p "Choose Yes (default, Deadbeef will be installed) otherwise (no) Audacious will be installed (Y/n)?" answer
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
        sudo apt -y update && sudo apt -y install audacious
        # set Audacious as default player
        sudo sed -i -e 's/deadbeef/audacious/g' /usr/share/applications/defaults.list
        
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

# DigiKam
echo "install the photo management tool (DigiKam), recommended for large photo collections (Y/n)?"
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

# Syncthing
echo "Syncthing is installed but turned off. Turn on and start at boot? (Y/n)?"
read -p "Syncthing is a fast and lightweight tool for 2-way syncing between your devices." answer
case ${answer:0:1} in
    y|Y )
       sudo systemctl enable syncthing@asterix.service
       sudo mv /etc/systemd/system/multi-user.target.wants/syncthing@.service /etc/systemd/system/multi-user.target.wants/syncthing@$LOGNAME.service
    ;;
    * )
        echo "Not enabling Syncthing..."
    ;;
esac

# Get a Firefox shortcut for 2 profiles
echo "If you share this laptop, you can right-click Firefox to select which Firefox profile to launch."
read -p "Only useful if each user has its own Firefox profile. Do you need this option (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo adding profiles to right-click of Firefox shortcut... 
        wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/firefox/firefox.desktop
    ;;
    * )
        echo "Keeping the Firefox shortcut as is..."
    ;;
esac

echo "DONE! please REBOOT now, type sudo reboot now and hit enter."
