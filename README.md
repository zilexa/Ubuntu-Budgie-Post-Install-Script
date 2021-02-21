## Ubuntu Budgie - Post Installation script 
## An Out Of The Box Experience - Carefully selected applications and configurations of system and apps. 
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

## How To Use:
Op the File Manager, go to Downloads
Right-click empty area, select "Terminal"
Now download and run the script:
```
wget https://raw.githubusercontent.com/zilexa/UbuntuBudgie-config/master/postinstall.sh
bash postinstall.sh
```

## What it does:

### Installs 'OS system addons': 
* Folder Colors - Allows you to organise your folders with colors and tags via right-click context menu.
* lm-sensors - allows system sensors read-out like temperature, fan speed. 
* tlp - install tlp to control performance and temperature automatically. Must-have for laptops.
* Timeshift - automated system backups via snapshots.
* appimagelauncher - Integrate AppImages at first launch.

### Default desktop: 
* A nice widescreen layout, highly recommended as it allows maximum usage of screen height with a vertical bar on the left side. 
* This layout can also be used horizontally (bottom, like Windows or top in combination with Plank dock like Mac. 
* Either way, it showcases the nice features of Budgie, with its applets such as one to quickly open a file, have 2 workspaces with their own customisable wallpaper and more. 
![screenshot of desktop layout](https://i.ibb.co/BNccrGp/nnn.png)

### touchpad gestures!
- Allow 3 and 4 finger gestures (like MacOS)
  - 3/4 fingers swipe up/down will show/hide all active windows
  - 2 finger swipe left/right will go to previous/next page in file manager and internet browsers
  - More gestures are possible

### Solves bugs or things I believe should be enabled by default:
* Touchpad scroll direction should match default scroll direction of mouse (solves a bug).
* Keyboard Print Scr button should trigger area selection for screenshot (solves a bug, you still have to hit the button twice fast).
* Set app defaults (solves a bug).
* Enable Window Previews for alt-tab (disabled by default).
* Allow slow doubleclick on filename to rename file (disabled by default).
* Disable doubleclick empty area to go up 1 folder (enabled by default leading to many misclicks and deletion risks).

### Toggles the following settings to match what most users from Windows and MacOS are used to: 
Note some of these settings are also applied for root, otherwise the experience is inconsistent.
* Dark mode
* Theme with clearer icons (ubuntu-mono-dark)
* Close/minimise/maximise buttons on the left side
* Folders always list view instead of big icon view
* Show reload folder button
* Week numbers in Raven calendar
* Change QuickNote path to /Documents
* Notifications top-left to match Panel on leftside (matches widescreen layout)
* Show battery percentage in taskbar
* Enable auto night light

## LibreOffice:
* Replaces icon for LibreOffice startcenter (default is a blank one, not very recognisable).
- Installs 3 sets of Microsoft Windows/Office fonts:  
  - Microsoft Vista TTF fonts like Verdana 
  - Cleartype TTF fonts from MS Office 2007 like Calibri
  - MS Segoeui TTF font

## Installs latest version of essential software
* Pluma - texteditor (replaces gedit, still simple & lightweight)
* Bleachbit - system cleanup
* Pinta - simple drawer/image editor like Microsoft Paint (replaces Drawing because it lacks zoom control to view a photo)
* AnyDesk -  Remote support
* DarkTable - (raw) photo editing

## Optional software (user can decide y/n)
* Spotify
* Musicplayer Deadbeef (it has folder tree view!) or Audacious, either way replacing Rhythmbox
* DigiKam - awesome photo management software
* RawTherapee ART - raw photo editor in addtion to DarkTable
* NoMachine - desktop share/remote desktop for within network, faster than built-in solution
* Add LibreOffice Dutch UI/Spellcheck/Hyphencheck/Help 
* Add 2 firefox profiles to the Firefox right-click shortcut
