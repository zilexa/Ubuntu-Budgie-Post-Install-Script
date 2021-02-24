OS Installation

I recommend a very fast USB stick. 
Sandisk Extreme Pro USB 3.1 128GB or Kingston HyperX Savage 256GB. They are MUCH faster than anything else (>300MB/s). 
Not only will installation go extremely fast (minutes), the stick will have triple functionality: 
1. Boot from it with fully functional Ubuntu Budgie OS to try out.
2. Install Ubuntu Budgie. 
3. Use it as general USB stick: copy data, backup data etc.  

STEP 1:
1. Download [Ventoy](https://www.ventoy.net/en/download.html). This tool allows you to create a bootdisk (read-only) and a seperate partition that can be used as general usb stick.
2. Go to https://ubuntubudgie.org/downloads/ and direct-download the latest image. 
3. Launch Ventoy and [follow the steps](https://www.ventoy.net/en/doc_start.html). For modern systems make sure you select GPT/UEFI instead of MBR unless you plan to use it on old systems. 

STEP2:
You now want to boot the PC and call the boot menu, to select the USB drive as boot disk.
Google "boot menu key" + the laptop, PC or motherboard brand, to figure out how to get the boot menu. 
Boot from the disk. 
Select "Install Ubuntu Budgie".

STEP3: recommended for this post-install script, required if you plan to use the system as homeserver:
1. When selecting where to install, make sure you select SOMETHING ELSE. 
2. Under the SSD you want to install on (for example nvmen0p1), there is a /boot/efi, must be 500 or 560 MB in size. If not, create a new table. 
3. Make sure you create a BTRFS filesystem on the SSD, with maximum size and mounted on "/". 

![Ubuntu Installation Wizard step 3.1](https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/OS-installation/Ubuntu-OS-setup-step3_1.png)Select "Something else"

![Ubuntu Installation Wizard step 3.1](https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/OS-installation/Ubuntu-OS-setup-step3_2.png)change "EXT4" to BTRFS!
