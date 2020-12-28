#!/bin/bash
#
# Welcome to Ubuntu Budgie! An intuitive, user friendly, light and fast Operating System. 
# For most people, it is better than Windows (10) or MacOS. It can easily look exactly like Windows or Mac.
# However that is not the goal of this script. This script will add features that will be standard features of upcoming releases. 
# Like gestures, folder colors and some nice applets. 
# It will also apply settings to make it feel more intuitive, settings that can easily be changed/reverted by the user. 

#__________________________________________
# filesystem configuration (BTRFS)
#__________________________________________
# Don't show bootmenu with BTRFS filesystem
sudo sed -i '1iGRUB_RECORDFAIL_TIMEOUT=0' /etc/default/grub
sudo update-grub
# Don't write to file each time a file is accessed
sudo sed -i -e 's#defaults,subvol=#defaults,noatime,subvol=#g' /etc/fstab
# Disable swap as it doesn't work out of the box with BTRFS and most systems don't need it or are better of using ZRAM
sudo swapoff -a
sudo rm -rf /swapfile


#___________________________________
# Budgie Desktop Extras & Essentials
#___________________________________
# Add repository for recommended Budgie stuff
sudo add-apt-repository -y ppa:ubuntubudgie/backports
sudo add-apt-repository -y ppa:costales/folder-color
sudo apt -y update

# Install common applets required for Widescreen Panel Layout or for file manager
sudo apt -y install budgie-kangaroo-applet
sudo apt -y install budgie-workspace-wallpaper-applet
sudo apt -y install budgie-calendar-applet
#sudo apt -y install folder-color-nemo #no longer supported in 20.10
#nemo -q # because not supported

# Install ExFat support
sudo apt -y install exfat-utils

# Install NFS supprt - Fastest way to access shared folders over the network (as a client)
sudo apt -y install nfs-common
# Add an example to /etc/fstab. Create a folder in /mnt, fill in your NAS IP address (X) and folder name (Y) and uncomment. 
echo "#" | sudo tee -a /etc/fstab
echo "# Example how to mount your servers NFS shares to a client:" | sudo tee -a /etc/fstab
echo "#192.168.88.X:  /mnt/Y  nfs4  nfsvers=4,minorversion=2,proto=tcp,fsc,nocto  0  0" | sudo tee -a /etc/fstab


#________________________________________________________________________
# Perform all actions from $HOME/Downloads, this allows automated cleanup
#________________________________________________________________________
# Just in case this script was not executed from ./Downloads
cd $HOME/Downloads


#__________________________________________________________________________________________
# Install applications and apply per app configurations (make them ready to use & intuitive
# -----------------------------------------------------------------------------------------
# Replace gedit for Pluma - better simple notepad 
# -----------------------------------------------
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

# Replace Rhythmbox for Deadbeef (much more intuitive and has folder-view)
# ------------------------------------------------------------------------
sudo apt -y autoremove rhythmbox --purge
wget https://downloads.sourceforge.net/project/deadbeef/travis/linux/1.8.4/deadbeef-static_1.8.4-1_amd64.deb
sudo apt -y install ./deadbeef*.deb
rm deadbeef*.deb
# Get config file and required pre-build plugins for layout
wget https://github.com/zilexa/deadbeef-config-layout/archive/master.zip
unzip master.zip
mv deadbeef-config-layout-master/lib $HOME/.local/
mkdir $HOME/.config/deadbeef/
mv deadbeef-config-layout-master/config $HOME/.config/deadbeef/
rm -r deadbeef-config-layout-master
rm master.zip

# All MS Office fonts
# --------------------
wget --no-check-certificate https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/libreoffice/officefonts.sh
sudo bash officefonts.sh
rm officefonts.sh

# Bleachbit - system cleanup
wget https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1910.deb
sudo apt -y install ./bleachbit*.deb
rm bleachbit*.deb
sudo wget -O /root/.config/bleachbit/bleachbit.ini https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/bleachbit/bleachbit.ini

# Audacity - Audio recording and editing
sudo apt -y install audacity

# Add repositories for applications that have their own up-to-date repository
# ---------------------------------------------------------------------------
# Timeshift repository
sudo add-apt-repository -y ppa:teejee2008/timeshift
# AppImageLauncher repository
sudo add-apt-repository -y ppa:appimagelauncher-team/stable
# TLP repository
sudo add-apt-repository -y ppa:linrunner/tlp
# AnyDesk repository
echo 'deb http://deb.anydesk.com/ all main' | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
# Syncthing repository
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing
# OnlyOffice DesktopEditors repository
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
sudo add-apt-repository -y "deb https://download.onlyoffice.com/repo/debian squeeze main"
# Photoflare repository
sudo add-apt-repository -y ppa:photoflare/photoflare-stable
# DarkTable repository
echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/xUbuntu_20.10/ /' | sudo tee /etc/apt/sources.list.d/graphics:darktable.list
curl -fsSL https://download.opensuse.org/repositories/graphics:darktable/xUbuntu_20.10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/graphics_darktable.gpg > /dev/null

# Reload repositories
# -------------------
sudo apt -y update

# Now install applications from added repositories
# ------------------------------------------------
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
# Install AnyDesk (remote support)
sudo apt -y install anydesk
sudo systemctl disable anydesk
# Syncthing - sync folders between devices
mkdir $HOME/.local/share/syncthing
sudo apt -y install syncthing
sudo wget -O /etc/systemd/system/syncthing@.service https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/syncthing/syncthing%40.service
# OnlyOffice - Better alternative for existing MS Office files
sudo apt -y install onlyoffice-desktopeditors
# DarkTable - pro photo editing
sudo apt -y install darktable
sudo apt-get install onlyoffice-desktopeditors
# Photoflare - simple image editing
sudo apt -y install photoflare


#_____________________________________________________
# Set app defaults (solves known Ubuntu Budgie issues)
# ____________________________________________________
sudo sed -i -e 's#rhythmbox.desktop#deadbeef.desktop#g' /etc/budgie-desktop/defaults.list
sudo sed -i -e 's#org.gnome.gedit.desktop#pluma.desktop#g' /usr/share/applications/defaults.list
sudo sed -i -e 's#org.gnome.Geary.desktop#thunderbird.desktop#g' /usr/share/applications/defaults.list
sudo wget -O $HOME/.config/mimeapps.list https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/mimeapps.list


#______________________________________________
# Configure Widescreen Panel and get seperators
# _____________________________________________
# Apply a much better icon for the LibreOffice StartCenter (by default it is plain white textfile icon)
sudo sed -i -e 's/Icon=libreoffice-startcenter/Icon=libreoffice-oasis-text-template/g' /usr/share/applications/libreoffice-startcenter.desktop
cp /usr/share/applications/libreoffice-startcenter.desktop $HOME/.local/share/applications
# replace override file otherwise some settings will be reverted back after reset and only default icons will be pinned
sudo wget --no-check-certificate -O /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/25_budgie-desktop-environment.gschema.override
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
# Add horizontal and vertical separator icons to the system
wget https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/seperators/separator-images.zip
unzip separator-images.zip
sudo mv {separatorH.svg,separatorV.svg} /usr/share/icons
rm -r separator-images.zip
# Add a fake app-shortcuts to use as a horizontal and vertical seperarators
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/seperators/SeparatorH1.desktop
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/seperators/SeparatorV1.desktop
# Switch to widescreen panel layout with medium sized icons
sudo wget --no-check-certificate -P /usr/share/budgie-desktop/layouts https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/budgie-desktop/widescreen.layout
gsettings set com.solus-project.budgie-panel layout 'widescreen'
# reset panel to apply changes
nohup budgie-panel --reset --replace &
# disable plank from autostarting
rm -r /home/$LOGNAME/.config/autostart/plank.desktop
# stop plank
sudo pkill plank
cd $HOME/Downloads
rm nohup.out


#____________________________
# Budgie Desktop basic config
#____________________________
# Dark mode
gsettings set com.solus-project.budgie-panel dark-theme true

# Dark but well-readable theme with icons more clear than the default set
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'

# close/minimise/maximise buttons on the left side (more common)
gsettings set com.solus-project.budgie-wm button-style 'left'

# folders always list view instead of big icon view
gsettings set org.nemo.preferences default-folder-viewer 'list-view'
sudo gsettings set org.nemo.preferences default-folder-viewer 'list-view'

# allow slow doubleclick on filename to rename file
gsettings set org.nemo.preferences quick-renames-with-pause-in-between true
sudo gsettings set org.nemo.preferences quick-renames-with-pause-in-between true

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
#gsettings set org.gnome.gnome-screenshot auto-save-directory "$HOME/Pictures/Screenshots"


#______________________________
# Allow 3 and 4 finger gestures
#______________________________
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


#_________________________________
# Simplify $HOME personal folders
#_________________________________
# Move /Desktop and /Templates to be subfolders of /Documents. Remove /Public folder and prevent it from being created
# This way, all you have to do is sync /Documents with your cloud provider and/or server (i.e. via Syncthing)
# First, rename and move contents from Pictures to Photos, Videos to Media 
mv $HOME/Pictures $HOME/Photos
mv $HOME/Videos $HOME/Media
sudo sed -i -e 's+$HOME/Desktop+$HOME/Documents/Desktop+g' $HOME/.config/user-dirs.dirs
sudo sed -i -e 's+$HOME/Templates+$HOME/Documents/Templates+g' $HOME/.config/user-dirs.dirs
sudo sed -i -e 's+$HOME/Public+$HOME+g' $HOME/.config/user-dirs.dirs
mv $HOME/Templates $HOME/Documents/
mv $HOME/Desktop $HOME/Documents/
rm -rf $HOME/Public

#____________________________________
# Create recommended BTRFS subvolumes
#____________________________________
wget --no-check-certificate https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/BTRFS-recommended-subvolumes.sh
bash BTRFS-recommended-subvolumes.sh
cd $HOME/Downloads
rm BTRFS-recommended-subvolumes.sh

#______________________________________
#          OPTIONAL SOFTWARE
#______________________________________
# KeepassXC Password Manager
echo "Install KeepassXC (Y/n)?"
read -p "The only free, reliable password manager that provides maximum security and can be synced between devices" answer
case ${answer:0:1} in
    y|Y )
       sudo add-apt-repository -y ppa:phoerious/keepassxc
       sudo apt update && sudo apt -y install keepassxc
    ;;
    * )
        echo "Not enabling Syncthing..."
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
       sudo systemctl enable syncthing@.service
       sudo ln -s /etc/systemd/system/syncthing@.service /etc/systemd/system/multi-user.target.wants/syncthing@$LOGNAME.service
    ;;
    * )
        echo "Not enabling Syncthing..."
    ;;
esac

# Install Spotify
read -p "Install Spotify (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo Installing Spotify by adding its repository...
        curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt -y update && sudo apt -y install spotify-client
    ;;
    * )
        echo "Skipping Spotify..." 
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
