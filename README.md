### Ubuntu Budgie unattended post installation configuration

#### Welcome to Ubuntu Budgie! An intuitive, user friendly, light and fast Operating System. 
For most people, it is better than Windows (10) or MacOS. It can easily look exactly like Windows or Mac.
However that is not the goal of this script. This script will add features that will be standard features of upcoming releases. 
Like gestures, folder colors and some nice applets. 
It will also apply settings to make it feel more intuitive, settings that can easily be changed/reverted by the user. 

How To Use:
Op the File Manager, go to Downloads
Right-click empty area, select "Terminal"
Now download and run the script:
```
wget https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/postinstall.sh
bash postinstall.sh
```

What it does:


 Create a system-wide environmental variable that will always point to the home folder of the logged in user
 Useful since Ubuntu 19.10. Now when you use sudo, this custom env-variable points to /home/username instead of /root.


Installs system tools: 
 Folder Colors - Allow customisable Folder Colors
 lm-sensors - enable system sensors read-out like temperature, fan speed
 tlp - install tlp to control performance and temperature automatically
 Timeshift - automated system snapshots (backups) 
 appimagelauncher - Integrate AppImages at first launch

Configures: 
 The Ubuntu Budgie Widescreen layout, highly recommended as it allows maximum usage of screen height with a vertical bar on the left side. 

Toggles the following settings to match what most users from Windows and MacOS are used to: 
 Dark mode
 Theme with clearer icons (ubuntu-mono-dark)
 close/minimise/maximise buttons on the left side (more common)
 folders always list view instead of big icon view
 disable doubleclick empty area to go up 1 folder (very annoying)
 allow slow doubleclick on filename to rename file (common)
 show reload folder button
 week numbers in Raven calendar
 get brightness, volume etc buttons on every laptop keyboard to work
 Enable Window Previews for alt-tab
 Change QuickNote path to /Documents
 Notifications Top-Left to match Panel on leftside (matches widescreen layout)
 Touchpad should match scroll direction of mouse (default of mouse is non-natural)
 Show battery percentage in taskbar
 Enable auto night light
 Print Scr should take area screenshot
 Allow 3 and 4 finger gestures (like MacOS)
 set app defaults (solves known Ubuntu Budgie issues)

LibreOffice specific:
 replace icon for LibreOffice startcenter (default is a blank one, not very recognisable)
 Install old MS Office fonts, new MS Office fonts and also current MS Office fonts

Installs Essential software
 Pluma - texteditor
 Bleachbit - system cleanup
 Pinta - Alternative to Drawing (like Ms Paint) 
 AnyDesk -  Remote support
 DarkTable - image editing

Optional software (user can decide y/n)
 Spotify
 Deadbeef (folder tree view) or Audacious music player
 DigiKam - awesome photo management software
 RawTherapee ART - raw photo editor in addtion to DarkTable
 NoMachine - desktop share/remote desktop for within network
 Add LibreOffice Dutch UI/Spellcheck/Hyphencheck/Help 
 Add 2 profiles to Firefox right-click shortcut

