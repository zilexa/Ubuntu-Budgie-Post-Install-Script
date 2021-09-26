#!/bin/bash
#
# Welcome to Ubuntu Budgie! An intuitive, user friendly, light and fast Operating System. 
# For most people, it is better than Windows (10) or MacOS. It can easily look exactly like Windows or Mac.
# However that is not the goal of this script. This script will add features that will be standard features of upcoming releases. 
# Like gestures, folder colors and some nice applets. 
# It will also apply settings to make it feel more intuitive, settings that can easily be changed/reverted by the user. 

echo "_________________________________________________________________________________________"
echo "BTRFS related configurations Ubuntu Installer hopefully will take care of in the future  "
echo "_________________________________________________________________________________________"
# Don't show bootmenu with BTRFS filesystem
sudo sed -i '1iGRUB_RECORDFAIL_TIMEOUT=0' /etc/default/grub
sudo update-grub
# Don't write to file each time a file is accessed
sudo sed -i -e 's#defaults,subvol=#defaults,noatime,subvol=#g' /etc/fstab
# Ubuntu should not mount a swapfile, it results in an error at boot when filesystem is btrfs. Comment it out in etc/fstab
sudo sed -i -e 's@/swapfile@#swapfile@g' /etc/fstab

echo "______________________________"
echo "Expand filesystem support     "
echo "______________________________"
# Install ExFat support
sudo apt -y install exfat-utils

# Install NFS supprt - Fastest way to access shared folders over the network (as a client)
sudo apt -y install nfs-common
# Add an example to /etc/fstab. Create a folder in /mnt, fill in your NAS IP address (X) and folder name (Y) and uncomment. 
echo "#" | sudo tee -a /etc/fstab
echo "# Example how to mount your servers NFS shares to a client:" | sudo tee -a /etc/fstab 
echo "#192.168.88.X:  /mnt/Y  nfs4  nfsvers=4,minorversion=2,proto=tcp,timeo=50,fsc,nocto  0  0" | sudo tee -a /etc/fstab

echo "___________________________________"
echo "Budgie Desktop Extras & Essentials "
echo "___________________________________"
# Add repository for recommended Budgie stuff
sudo add-apt-repository -y ppa:ubuntubudgie/backports
## sudo add-apt-repository -y ppa:costales/folder-color not supported?
sudo apt -y update

# Allow each Workspace (virtual desktop) to have its own wallpaper
sudo apt -y install budgie-workspace-wallpaper-applet

# Show a calendar when clicking on the time
sudo apt -y install budgie-calendar-applet

# Allow a Desktop wallpaper slideshow based on users photos or Bing photos (default)
sudo apt -y install variety

# Install Ubuntu Restricted Extras
# Note this (and OnlyOffice which will be installed later) triggers MS truetype fonts installer which requires manual user acceptance of license.
#nstall it first unattendedly to prevent user-interaction
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt -y install ttf-mscorefonts-installer
sudo apt -y install ubuntu-restricted-extras


#________________________________________________________________________
# Perform all actions from $HOME/Downloads, this allows automated cleanup
#________________________________________________________________________
# Just in case this script was not executed from ./Downloads
cd $HOME/Downloads

echo "___________________________________________________________________________________________"
echo "Install applications and apply per app configurations (make them ready to use & intuitive) "
echo "___________________________________________________________________________________________"

echo "-------------------------------------------------"
echo "Replace gedit for Pluma - better simple notepad  "
echo "-------------------------------------------------"
sudo apt -y install pluma

# 
echo "-------------------------------------------------------------------------------------------------"
echo "Replace Rhythmbox audioplayer for Deadbeef (more intuitive, bitperfect playback and folder view) "
echo "-------------------------------------------------------------------------------------------------"
#sudo apt -y autoremove rhythmbox --purge
wget -O deadbeef.deb https://downloads.sourceforge.net/project/deadbeef/travis/linux/1.8.7/deadbeef-static_1.8.7-1_amd64.deb
sudo apt -y install ./deadbeef.deb
rm deadbeef.deb
# Get config file and required pre-build plugins for layout
wget https://github.com/zilexa/deadbeef-config-layout/archive/master.zip
unzip master.zip
mv deadbeef-config-layout-master/lib $HOME/.local/
mkdir $HOME/.config/deadbeef/
mv deadbeef-config-layout-master/config $HOME/.config/deadbeef/
rm -r deadbeef-config-layout-master
rm master.zip

echo "------------------------------------------------------------------------------------------------"
echo "LibreOffice by default only supports US English. Add proper UK English support and NL support   "
echo "------------------------------------------------------------------------------------------------"
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo apt update
sudo apt install -y libreoffice-l10n-en-gb hunspell-en-gb hyphen-en-gb libreoffice-help-en-gb libreoffice-l10n-nl hunspell-nl hyphen-nl libreoffice-help-nl

echo "--------------------------------------------------"
echo "Install Bleachbit to cleanup the system regularly "
echo "--------------------------------------------------"
# Bleachbit - system cleanup
wget -O bleachbit.deb https://download.bleachbit.org/bleachbit_4.2.0-0_all_ubuntu2010.deb
sudo apt -y install ./bleachbit.deb
rm bleachbit.deb
sudo mkdir -p /root/.config/bleachbit
sudo wget -O /root/.config/bleachbit/bleachbit.ini https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/bleachbit/bleachbit-root.ini
sudo mkdir $HOME/.config/bleachbit/
wget -O $HOME/.config/bleachbit/bleachbit.ini https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/bleachbit/bleachbit-user.ini

echo "---------------------------------------"
echo "Audacity - Audio recording and editing "
echo "---------------------------------------"
sudo apt -y install audacity

echo "-----------------------------------------------------"
echo "VLC - videoplayer in addition to default (Celluloid) "
echo "-----------------------------------------------------"
# VLC - video playback, Celluloid is still the default player but some videos need VLC plus it is the easiest tool to rip a DVD
sudo apt -y install vlc

echo "__________________________________________________________________________________________________"
echo "Some applications we want are outdated in Ubuntu repository, add the app developer own repository "
echo "__________________________________________________________________________________________________"
# Timeshift repository
sudo add-apt-repository -y ppa:teejee2008/timeshift
# AppImageLauncher repository
sudo add-apt-repository -y ppa:appimagelauncher-team/stable
# OnlyOffice DesktopEditors repository
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
sudo add-apt-repository -y "deb https://download.onlyoffice.com/repo/debian squeeze main"
# Photoflare repository
sudo add-apt-repository -y ppa:photoflare/photoflare-stable
# DarkTable repository
echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/xUbuntu_21.04/ /' | sudo tee /etc/apt/sources.list.d/graphics:darktable.list
curl -fsSL https://download.opensuse.org/repositories/graphics:darktable/xUbuntu_21.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/graphics_darktable.gpg > /dev/null

# Reload repositories
# -------------------
sudo apt -y update

echo "_________________________________________________"
echo "Now install applications from added repositories "
echo "_________________________________________________"
echo "------------------------------------------------------------------"
echo "Install support for Flatpak apps and install the FlatHub app store"
echo "------------------------------------------------------------------"
sudo apt -y install flatpak
sudo apt -y install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "-------------------------------------------------"
echo "Install Timeshift for automated system snapshots "
echo "-------------------------------------------------"
# Timeshift - automated system snapshots (backups) and set configuration
sudo apt -y install timeshift
sudo wget -O /etc/timeshift/timeshift.json https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/timeshift/timeshift.json
sudo sed -i -e 's#asterix#'"${USER}"'#g' /etc/timeshift/timeshift.json

echo "-------------------------------------------------"
echo "Integrate AppImages at first launch              "
echo "-------------------------------------------------"
sudo apt -y install appimagelauncher
# Create folder to move appimages to when integrating them into the system
sudo mkdir /opt/appimages
sudo chown ${USER}:${USER} /opt/appimages
sudo chmod 755 /opt/appimages
# Add AppImageLauncher config file to specify this folder
tee -a $HOME/.config/appimagelauncher.cfg &>/dev/null << EOF
[AppImageLauncher]
destination=/opt/appimages
enable_daemon=false
EOF
echo "-------------------------------------------------"
echo "Install OnlyOffice DesktopEditors                "
echo "-------------------------------------------------"
sudo apt -y install onlyoffice-desktopeditors
# Apply a much better icon for the LibreOffice StartCenter (by default it is plain white textfile icon)
sudo sed -i -e 's/Icon=libreoffice-startcenter/Icon=libreoffice-oasis-text-template/g' /usr/share/applications/libreoffice-startcenter.desktop
cp /usr/share/applications/libreoffice-startcenter.desktop $HOME/.local/share/applications

echo "-------------------------------------------------"
echo "Install DarkTable - pro photo editor             "
echo "-------------------------------------------------"
sudo apt -y install darktable
echo "-------------------------------------------------"
echo "Install Photoflare - simple photo editor         "
echo "-------------------------------------------------"
sudo apt -y install photoflare
echo "-------------------------------------------------"
echo "Install Pinta - simple (like Paint) image editor "
echo "-------------------------------------------------"
sudo flatpak install flathub com.github.PintaProject.Pinta
# enable system sensors read-out like temperature, fan speed
echo "-------------------------------------------------"
echo "Install lm-sensors and find system sensors       "
echo "-------------------------------------------------"
sudo apt -y install lm-sensors
sudo sensors-detect --auto

echo "____________________________________________________________________"
echo "set Deadbeef as default musicplayer and Pluma as default texteditor "
echo "____________________________________________________________________"
sudo sed -i -e 's#rhythmbox.desktop#deadbeef.desktop#g' /etc/budgie-desktop/defaults.list
sudo sed -i -e 's#org.gnome.gedit.desktop#pluma.desktop#g' /usr/share/applications/defaults.list
sudo wget -O $HOME/.config/mimeapps.list https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/mimeapps.list


echo "___________________________________________________________________________________"
echo "Firefox: Create a default profile setting to enable syncing of your toolbar layout " 
echo "         (Applied for for all Firefox profiles created in the future.)             "
echo "___________________________________________________________________________________"
sudo tee -a /usr/lib/firefox/defaults/pref/autoconfig.js &>/dev/null << EOF
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF
sudo tee -a /usr/lib/firefox/firefox.cfg &>/dev/null << EOF
// IMPORTANT: Start your code on the 2nd line
defaultPref("services.sync.prefs.sync.browser.uiCustomization.state",true);
#defaultPref("identity.sync.tokenserver.uri","https://YOUR.DOMAIN.TLD/token/1.0/sync/1.5");
EOF


echo "____________________________________"
echo "Configure Widescreen vertical Panel "
echo "____________________________________"
# Replace default 21.04 Budgie UI configuration for one for additional settings
sudo wget --no-check-certificate -O /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/25_budgie-desktop-environment.gschema.override
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

# Switch to widescreen panel layout with medium sized icons
sudo wget --no-check-certificate -P /usr/share/budgie-desktop/layouts https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/widescreen.layout
gsettings set com.solus-project.budgie-panel layout 'widescreen'
# reset panel to apply changes
nohup budgie-panel --reset --replace &
# disable plank from autostarting
rm -r /home/$LOGNAME/.config/autostart/plank.desktop
# stop plank
sudo pkill plank
cd $HOME/Downloads
rm nohup.out

echo "______________________________________________________________________________"
echo "For the app Dock (Plank), get seperators that you can use as apps in the dock "
echo "______________________________________________________________________________"
# For Plank (the bottom MacOS-like dock) add horizontal and vertical separator icons
# Get the images
wget https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/seperators/separator-images.zip
unzip separator-images.zip
sudo mv {separatorH.svg,separatorV.svg} /usr/share/icons
rm -r separator-images.zip
# Add a fake app-shortcuts to use as a horizontal and vertical seperarators
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/seperators/SeparatorH1.desktop
wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/seperators/SeparatorV1.desktop


# Print Scr should take area screenshot - THIS IS OUTDATED
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

echo "___________________________________________"
echo "   Allow 3 and 4 finger touchpad gestures  "
echo "___________________________________________"
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
wget -O $HOME/.config/libinput-gestures.conf https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/budgie-desktop/libinput-gestures.conf
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


echo "_______________________________________"
echo "   Simplify $HOME personal folders     "
echo "_______________________________________"
# Change default location of personal folders by editing $HOME/.config/user-dirs.dirs
## Move /Templates to be subfolder of /Documents. 
sudo sed -i -e 's+$HOME/Templates+$HOME/Documents/Templates+g' $HOME/.config/user-dirs.dirs
## Disable Public folder because nobody uses it. 
sudo sed -i -e 's+$HOME/Public+$HOME+g' $HOME/.config/user-dirs.dirs
## Rename Pictures to Photos
sudo sed -i -e 's+$HOME/Pictures+$HOME/Photos+g' $HOME/.config/user-dirs.dirs
## Rename Videos to Media making it the folder for tvshows/movies downloads or anything else that is not suppose to be in Photos. 
sudo sed -i -e 's+$HOME/Videos+$HOME/Media+g' $HOME/.config/user-dirs.dirs

# Now make the changes to the actual folders: 
## Remove unused Pubic folder
rmdir $HOME/Public
## Move Templates folder into Documents because it does not make sense to be outside it. 
mv $HOME/Templates $HOME/Documents/
## Rename and move contents from Pictures to Photos, Videos to Media.
mv /home/${USER}/Videos /home/${USER}/Media
mv /home/${USER}/Pictures /home/${USER}/Photos


echo "_______________________________________"
echo "  Create recommended BTRFS subvolumes  "
echo "_______________________________________"
# HIGHLY RECOMMENDED: Create nested subvolume for /tmp
cd /
sudo mv /tmp /tmpold
sudo btrfs subvolume create tmp
sudo chmod 1777 /tmp
sudo mv /tmpold/* /tmp
sudo rm -r /tmpold
# HIGHLY RECOMMENDED: Create nested subvolume for $HOME/.cache
cd $HOME
mv ~/.cache ~/.cacheold
btrfs subvolume create .cache
mv .cacheold/* .cache
rm -r .cacheold/
# HIGHLY RECOMMENDED: disable CoW for /var/log
sudo chattr -R  +C /var/log
# CREATE A MOUNTPOINT FOR THE FILESYSTEM ROOT
sudo mkdir /mnt/system
cd $HOME/Downloads

echo "_______________________________________________________________________________________________________________________________________"
echo "Finished! Check the above for errors, run the relevant commands manually again if there was an error                                   " 
echo "Most errors appear if the Ubuntu server was down or overwhelmed, simply open the script, find the app that failed and run the commands " 
echo "If server is still down, choose a different server for your country via the app 'Software Sources'                                     " 
echo "But first, continue with the optional tasks below:                                                                                     "
echo "_______________________________________________________________________________________________________________________________________"
# OPTIONAL: IF THIS IS A COMMON PC OR LAPTOP, CREATE A SUBVOLUME FOR USER DATA.  
echo "======================================="
echo "---------------------------------------"
echo "Hit y if this a regular, personal device, laptop/desktop pc ( y /n )?"
echo "Yes: Personal folders will be moved to (and linked back to home) and swapfile created on seperate root subvolumes. Swap will be properly configured for BTRFS."
read -p "No: Nothing will be configured, make sure personal data is stored on a seperate subvolume and consider a swapfile or alternatively configure zram." answer
case ${answer:0:1} in
    y|Y )
# Temporarily mount filesystem root
sudo mount -o subvolid=5 /dev/nvme0n1p2 /mnt/system
# create a root subvolume for user personal folders in the root filesystem
sudo btrfs subvolume create /mnt/system/@userdata
sudo btrfs subvolume create /mnt/system/@swap
sudo chattr +C /mnt/system/@swap
## unmount root filesystem
sudo umount /mnt/system

# Add lines to fstab to make it persistent after boot, you should manually fill in the UUID before rebooting
sudo tee -a /etc/fstab &>/dev/null << EOF
# Mount @swap subvolume
UUID=COPYPASTE-THE-LONG-UUID-FROM-THE-TOP /swap                   btrfs   defaults,noatime,subvol=@swap  0  0
/swap/swapfile none swap sw 0 0
# Mount the BTRFS root subvolume @userdata
UUID=COPYPASTE-THE-LONG-UUID-FROM-THE-TOP /mnt/userdata           btrfs   defaults,noatime,subvol=@userdata,compress-force=zstd:2  0  0
EOF

# Temporarily mount @swap and finish configuration 
#sudo mkdir /swap
##sudo mount -o subvol=@swap /dev/nvme0n1p2 /swap
# Configure swap file
sudo chattr +C /swap
sudo touch /swap/swapfile
sudo chmod 600 /swap/swapfile
sudo dd if=/dev/zero of=/swap/swapfile bs=1024 count=2097152
sudo mkswap /swap/swapfile
sudo swapon /swap/swapfile
# Change default swappiness from 60 to 10 to swap less. 
echo -e "vm.swappiness=0" | sudo tee -a /etc/sysctl.conf

## Temporarily mount @userdata subvolume and finish configuration
sudo mkdir /mnt/userdata
sudo mount -o subvol=@userdata /dev/nvme0n1p2 /mnt/userdata
## Move personal user folders to the subvolume
## Note I have already moved Desktop and Templates to my Documents folder via my config.sh file.  
sudo mv /home/${USER}/Documents /mnt/userdata/
sudo mv /home/${USER}/Desktop /mnt/userdata/
sudo mv /home/${USER}/Downloads /mnt/userdata/
sudo mv /home/${USER}/Media /mnt/userdata/
sudo mv /home/${USER}/Music /mnt/userdata/
sudo mv /home/${USER}/Photos /mnt/userdata/

## Link personal folders inside subvolume back into home subvolume
ln -s /mnt/userdata/Documents $HOME/Documents
ln -s /mnt/userdata/Desktop $HOME/Desktop
ln -s /mnt/userdata/Downloads $HOME/Downloads
ln -s /mnt/userdata/Media $HOME/Media
ln -s /mnt/userdata/Music $HOME/Music
ln -s /mnt/userdata/Photos $HOME/Photos

#Current Downloads folder has been moved, enter the moved Downloads folder 
cd /
cd $HOME
cd $HOME/Downloads

## Now open fstab for the user to copy paste the UUID
echo "==========================================================================================================="
echo "-----------------------------------------------------------------------------------------------------------"
echo "Almost done, now a 2nd window will open and you need to copy/paste with your mouse the UUID from the top"
echo "And paste it where it says !!Copy UUID HERE !!"
echo "Then save changes with CTRL+O and exit the file with CTRL+X"
echo "-----------------------------------------------------------------------------------------------------------"
read -p "Are you ready to do this? Hit Enter and enter your password in the 2nd window to open the file."
x-terminal-emulator -e sudo nano /etc/fstab
read -p "When done in the 2nd window, hit ENTER in this window to continue..."
cd /
cd $HOME
cd $HOME/Downloads

    ;;
    * )
        echo "Not creating userdata, this is not a common personal device." 
    ;;
esac

echo "==========================================================================================" 
echo "                                                                                          " 
echo "OnlyOffice default document language & spellcheck is US English.                          "
echo "To change it to your language, you need to adjust the default template.                   "
echo "OnlyOffice has no way of doing this normally and permissions prevent you to do this easily" 
echo "                                                                                          "
echo "To switch from English to Dutch (NL) hit 'y' and 'ENTER.'                                 "
echo "Note this will not change the OnlyOffice interface language, it's not available in NL     " 
echo "                                                                                          "
echo "To use a different language, hit 'n'and 'ENTER' and follow the instructions.              "
echo "                                                                                          " 
echo "==========================================================================================" 
read -p " y or n (ENTER) ?" answer
case ${answer:0:1} in
    y|Y )
    cd /opt/onlyoffice/desktopeditors/converter/empty/
    sudo mkdir nl-NL
    echo "downloading preconfigured NL templates..." 
    sudo wget -O nl-NL/new.docx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.docx
    sudo wget -O nl-NL/new.pptx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.pptx
    sudo wget -O nl-NL/new.xlsx https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/onlyoffice/new.xlsx
    echo "moving files to the correct dir, replacing other templates with copies.." 
    # Copy the templates to the converter/empty dir
    sudo cp nl-NL/new.* ./
    # Remove the templates with prefix in_ and _mm as we need to replace them
    sudo rm in_*
    sudo rm mm_*
    # Copy the new.* templates and rename the copies by adding in_ prefix
    for f in new.*; do sudo cp -- "$f" "in_$f"; done
    # Rename the new.* templates, add mm_ 
    for f in new.*; do sudo mv -- "$f" "mm_$f"; done
    echo "done!" 
    cd $HOME/Downloads
    ;;
    * )
        read -p "Hit a button to open the instructions: https://github.com/zilexa/Ubuntu-Budgie-Post-Install-Script/tree/master/onlyoffice"
        echo "Please continue here before starting with the instructions" 
        sudo xdg-open https://github.com/zilexa/Ubuntu-Budgie-Post-Install-Script/tree/master/onlyoffice

    ;;
esac

#______________________________________
#          OPTIONAL SOFTWARE
#______________________________________
# Install ALL Win10/Office365 fonts
echo "======================================="
echo "---------------------------------------"
echo "A few MS Office available for Linux + a few commonly used additional MS Office fonts have been installed by this script." 
echo "However, if you want your documents to look identical, you need to install all MS Office fonts."
echo "If you believe you have the right to do so, the script will download a prepackaged copy of all MS Office365/Win10 fonts and install them."
read -p "The win10-fonts.zip archive is required. Your browser will open the download page, continue (Y) or skip (N)? (Y/n)" answer
case ${answer:0:1} in
    y|Y )
       xdg-open https://mega.nz/file/u4p02JCC#HnJOVyK8TYDqEyVXLkwghDLKlKfIq0kOlX6SPxH53u0
       read -p "Click any key when the download has finished completely..."
       echo "please wait while extracting fonts to the system fonts folder (/usr/share/fonts), the downloaded file will be deleted afterwards." 
       # Extract the manually downloaded file to a subfolder in the systems font folder
       sudo tar -xf $HOME/Downloads/fonts-office365.tar.xz -C /usr/share/fonts
       # Set permissions to allow non-root to use the fonts
       sudo chown -R root:root /usr/share/fonts/office365
       sudo chmod -R 755 /usr/share/fonts/office365
       # Refresh the font cache (= register the fonts)
       sudo fc-cache -f -v
       # Remove the downloaded font file
       rm $HOME/Downloads/fonts-office365.tar.xz
    ;;
    * )
        echo "Not installing all win10/office365 fonts..."
    ;;
esac

# Install Nextcloud Desktop Client for webDAV syncing with FileRun 
echo "======================================="
echo "---------------------------------------"
read -p "Install Nextcloud Desktop Client for Nemo/Budgie? Recommended if you run a FileRun or WebDAV server (y / n)?" answer
case ${answer:0:1} in
    y|Y )
        sudo add-apt-repository -y ppa:nextcloud-devs/client
        sudo apt update
        sudo apt -y install nemo-nextcloud
    ;;
    * )
        echo "Skipping Nextcloud Desktop Client..."
    ;;
esac

# Install losslesscut 
echo "======================================="
echo "---------------------------------------"
read -p "Install LosslessCut? it is the recommended solution to allow easy, userfriendly trimming of your camera videos without effecting video quality" answer
case ${answer:0:1} in
    y|Y )
        echo Installing LosslessCut...
        #Download & extract the file
        wget -qO- https://github.com/mifi/lossless-cut/releases/latest/download/LosslessCut-linux.tar.bz2 | tar jxvf -
        # Move the extracted folder to the app folder
        sudo mv LosslessCut-linux/ /opt/LosslessCut
        # Create a shortcut file for all users & make it executable
        sudo tee -a /usr/share/applications/LosslessCut.desktop &>/dev/null << EOF
[Desktop Entry]
Name=LosslessCut
GenericName=Video Editor
Comment=LosslessCut video editor.
Type=Application
Exec=/opt/LosslessCut/losslesscut
Icon=video-player
Categories=AudioVideo;Video;AudioVideoEditing
EOF
        sudo chmod +x /usr/share/applications/LosslessCut.desktop    
    ;;
    * )
        echo "Skipping LosslessCut video editor..." 
    ;;
esac

# Install HandBrake 
echo "======================================="
echo "---------------------------------------"
read -p "Install HandBrake? it allows easy, userfriendly conversion of your camera videos, DVDs etc to regular formats with or without compression." answer
case ${answer:0:1} in
    y|Y )
        echo Installing HandBrake...
        # Install handbrake + cli version from standard Ubuntu repository 
        sudo apt -y install handbrake && sudo apt -y install handbrake-cli
    ;;
    * )
        echo "Skipping Handbrake..." 
    ;;
esac

# Install Spotify
echo "======================================="
echo "---------------------------------------"
read -p "Install Spotify (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo Installing Spotify by adding its repository...
        # Add encryption key for the repository
        curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
        # Add the repository
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        # Refresh repositories and install spotify
        sudo apt -y update && sudo apt -y install spotify-client
    ;;
    * )
        echo "Skipping Spotify..." 
    ;;
esac

# DigiKam
echo "======================================="
echo "---------------------------------------"
echo "install the photo management tool (DigiKam), recommended for large photo collections (Y/n)?"
read -p "(The downloadpage will open in your browser. choose the Linux 64-bit AppImage.)" answer
case ${answer:0:1} in
    y|Y )
       # Open the download page
       xdg-open https://www.digikam.org/download/
       mkdir $HOME/Photos/.digiKam-db
       chattr +C $HOME/Photos/.digiKam-db
    ;;
    * )
        echo "Skipping DigiKam..."
    ;;
esac

# Firefox: configure Firefox Sync Server
echo "======================================="
echo "---------------------------------------"
read -p "Would you like to use your own Firefox Sync Server? (y/n)" answer
case ${answer:0:1} in
    y|Y )
    echo "Please type your Firefox Sync domain address, for example: firefox.mydomain.com"
    read -p 'Firefox Sync domain address: ' ffsyncdomain
    sudo tee -a /usr/lib/firefox/firefox.cfg &>/dev/null << EOF
defaultPref("identity.sync.tokenserver.uri","https://$ffsyncdomain/token/1.0/sync/1.5");
EOF
    echo "Done. New firefox profile will use your Firefox sync server by default."
    ;;
    * )
        echo "default Mozilla public sync server is used."
    ;;
esac

# Get a Firefox shortcut for 2 profiles
echo "======================================="
echo "---------------------------------------"
echo "Firefox: would you like to be able to launch different profiles (2), by simply right-clicking the Firefox shortcut?"
read -p "Only useful if multiple users use this machine and each user has its own Firefox profile. (y/n)?" answer
case ${answer:0:1} in
    y|Y )
        echo adding profiles to right-click of Firefox shortcut... 
        wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/firefox/firefox.desktop
    ;;
    * )
        echo "Keeping the Firefox shortcut as is..."
    ;;
esac

# RawTherapee ART
echo "======================================="
echo "---------------------------------------"
echo "DarkTable is a (raw) photo editor and has been installed already. Would you also like to install RawTherapee ART (Y/n)?"
read -p "(The downloadpage will open.)" answer
case ${answer:0:1} in
    y|Y )
       # Open the download page
       xdg-open https://bitbucket.org/agriggio/art/downloads/
    ;;
    * )
        echo "Skipping RawTherapee..."
    ;;
esac

# Anydesk
echo "======================================="
echo "---------------------------------------"
echo "install Anydesk for remote support? (Y/n)"
read -p "Recommended unless you only want remote support via VPN, in that case xrdp/x11vnc is a better choice." answer
case ${answer:0:1} in
    y|Y )

       echo 'deb http://deb.anydesk.com/ all main' | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
       wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
       sudo apt -y install anydesk
       # Do not autostart Anydesk with system. 
       sudo systemctl disable anydesk
    ;;
    * )
        echo "Skipping AnyDesk..."
    ;;
esac

# Remove RPi ARM TweakTool
echo "======================================="
echo "---------------------------------------"
read -p "Is this a Raspberry Pi? If no, the Raspberry Pi ARM Tweaktool will be removed to prevent popup (y/n)?" answer
case ${answer:0:1} in
    n|N )
        sudo apt -y autoremove budgie-arm-environment
    ;;
    * )
        echo "Skipping RPi ARM Tweaktool removal.."
    ;;
esac
echo "DONE! please REBOOT now, type sudo reboot now and hit enter."
