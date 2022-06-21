## After 2 years of Ubuntu (switched cold-turkey from Windows 10) I discovered Arch based distributions and decided to switch to Manjaro Gnome. This repository is now outdated and replaced by https://github.com/zilexa/manjaro-gnome-post-install
### An Out Of The Box Experience - Carefully selected applications and configurations of system and apps. 
A single script to run after installing Ubuntu Budgie. When the script is finished, your PC/Laptop is immediately ready, everything just works, there is an app for all common tasks. Similar to a Mac but better, faster and with more functionality. 
Every app or system configuration has been carefully chosen. No bloat!

#### Welcome to Ubuntu Budgie! An intuitive, user friendly, light and fast Operating System. 
For most people, it is better than Windows (10) or MacOS. It can easily look exactly like Windows or Mac.
However that is not the goal of this script. This script will add features that could become standard features of upcoming releases. 
Like gestures, folder colors and some nice applets. 
It will also apply settings to make it feel more intuitive for both Windows and MacOS users, even adding the most used Apple touchpad gestures! Most settings can easily be changed/reverted by the user.

This script simply allows you configure your fresh Ubuntu Budgie system automatically, so that you don't have to do these things manually or figure out where you can configure it.

Just sit back and relax. At the end, a few optional apps can be installed.

Note that most apps are installed via their own repository (if available). This way, you have the latest version and the system will check for updates automatically.

## 1. Important steps during Ubuntu (Budgie) Installation. 
Please read [OS Installation Steps](https://github.com/zilexa/Ubuntu-Budgie-Post-Install-Script/blob/master/OS-installation/README.md) first as I highly recommend to use BtrFS as the filesystem. 
It is robust, fast, protects your data and highly mature. 

## 2. How To Use the post-install script:
Op the File Manager, go to Downloads
Right-click empty area, select "Terminal"
Now download and run the script:
```
cd Downloads
wget https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/postinstall.sh
bash postinstall.sh
```

# Features
In order of appearance in the script.

## Folderstructure to support BTRFS + Best Practices
_BTRFS is a modern Copy-On-Write filesystem that protects files against disk failures and bitrot. It also allows instant file copy and instant snapshots and supports very fast backup transfers with verified file integrity. 
* Following BTRFS best practices: the script (optionally) creates a root subvolume "userdata" and moves the personal folders there, symlinking them back to the /Home folder. Takes care of adding the mounts to etc/fstab.
* Replaces several folders for nested subvolumes to exclude during backups (/tmp, home/../.cache)
* Solves the issue with Ubuntu not configuring a swapfile: creates swap subvolume with proper swapfile.
* Solves the issue with Ubuntu showing the Grub boot menu every time when BTRFS is used.
* Adds ZSTD recommended compression for personal data (userdata subvolume).
* Adds "noatime" option to all mount points to preserve your disk drives. 

### Installs recommended system tools
* lm-sensors - allows system sensors read-out like temperature, fan speed.
* Timeshift - Simple tool that supports automated "timeline" of system snapshots via BTRFS snapshots.
* btrbk + easy config - best tool to fully automate backups, if you don't have a backup disk, just use Timeshift.
* appimagelauncher - Integrate AppImages at first launch. Solves issue with AppImageLauncher: configured to install apps in /opt where they belong!
* Flatpak - install flatpak app support and Flatpak App Store.
* Installs Ubuntu Restricted Extras in case you forgot to do this during setup.
* Installs exfat to support disks formatted as exfat (USB sticks etc).
* Installs NFS to support the fastest network share protocol (15-30% faster than Windows share/Samba).

### Configure the desktop UI: Clean, minimal, practical & pretty 
_Ubuntu Budgie allows you to use a MacOS like applications dock with a top screen bar, or a Windows like taskbar with start menu button. This script uses a well thought through vertical taskbar: this makes sense because your screen has more space in width than in height: it allows maximum usage of screen for the important stuff._
* This layout can also be used horizontally (bottom, like Windows or top in combination with Plank dock like Mac. 
* Either way, it showcases the nice features of Budgie, with its applets such as one to quickly open a file, have 2 workspaces with their own customisable wallpaper and more. 
![screenshot of desktop layout](https://i.ibb.co/BNccrGp/nnn.png)
* Installs recommended Calendar applet to replace the Clock, Workspace Wallpaper switcher etc. 
* Easily switch between virtual desktops.

### touchpad gestures!
- Allow 3 and 4 finger gestures (like MacOS).
  - 3/4 fingers swipe up/down will show/hide all active windows.
  - 2 finger swipe left/right will go to previous/next page in file manager and internet browsers.
  - More gestures are possible.

### Toggles the following settings to match what most users from Windows and MacOS are used to: 
* Dark mode
* Theme with clearer icons (ubuntu-mono-dark)
* Close/minimise/maximise buttons on the left side
* Folders always list view instead of big icon view
* Show reload folder button
* Allow slow doubleclick on filename to rename file (disabled by default).
* Week numbers in Raven calendar
* Change QuickNote path to /Documents
* Notifications top-left to match Panel on leftside (matches widescreen layout)
* Show battery percentage in taskbar
* Enable auto night light
* Touchpad scroll direction should match default scroll direction of mouse (solves a bug).
* Enable Window Previews for alt-tab (disabled by default).

## Seamlessly move away from Microsoft Office with OnlyOffice
* Installs OnlyOffice DesktopEditors and allows you to set a default document/spellcheck language! 
* OnlyOffice is build to work with Microsoft docx/xlsx/pptx files and has a familiar UI. 
* Alternatively, LibreOffice is part of Ubuntu Budgie by default but with a less friendly UI and document support is focused on open, less used formats. The script adds support for UK English and replaces icon for LibreOffice startcenter (default is a blank one, not very recognisable).

## Installs latest version of essential software
Where it makes sense and a well known, official repository is available, the apps are installed via their own repository. This way you have the latest version and apps are automatically updated via the OS. 
* Pluma - Text Editor - replaces Gedit wich is extremely bare. 
* Deadbeef - Music player - replaces RythmBox - allows Folder View, Bitperfect audio and has a clean and simple UI.
* Bleachbit - system cleanup
* Darktable - professional photo editor
* PhotoFlare - simple photo editor
* Pinta - like Paint: a simple drawer/image editor 

## Optional software (user can decide y/n)
* All Office365 fonts (note: only use the downloadlink if you believe you are allowed to by MS).
* OnlyOffice: Change default language/spellchecker from English to Dutch or use link to tutorial to set your own language.
* Nextcloud Desktop Client - Even if you don't use Nextcloud, this is the only 2-way sync webDAV tool for Linux. Recommended for selfhosted cloud solutions like FileRun, Nextcloud, Owncloud.
* LosslessCut - very quick and easy video editor to trim videos without quality loss.
* Handbrake - convert videos from phone, camera etc to regular video format.
* DigiKam - awesome photo management software
* Audacity - the best and standard audio editor, to record audio from old media, edit mp3s etc.
* RawTherapee ART - raw photo editor in addtion to DarkTable.
* AnyDesk - remote support
* Add 2 firefox profiles to the Firefox right-click shortcut
* Remove RPi ARM Tweaktool - strangely this is installed by default even on non-ARM based systems. 
