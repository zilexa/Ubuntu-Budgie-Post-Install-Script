# BTRFS (B-Tree) filesystem allows you to easily create snapshots.
# To exclude folders that are not required when restoring a system snapshot, those folders need to be replaced by BTRFS subvolumes.
# Maybe it makes sense to exclude more system folders. Currently focusing on Ubuntu Budgie 20.10. In my experience only a few should be excluded from a system snapshot. 
#
# The "system" folders that just need to be excluded will be replaced by nested subvolumes.
# Personal data folders that need to be excluded and grouped into a single subvolume will be a subvolume called @userdata in the root of BTRFS, just like @ and @home.
#
# This is the common and recommended way of using BTRFS in a home laptop/pc environment.


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

# GOOD PRACTICE: disable CoW for /var/log
sudo chattr -R  +C /var/log


# CREATE A MOUNTPOINT FOR THE FILESYSTEM ROOT
sudo mkdir /mnt/system
# Temporarily mount filesystem root
sudo mount -o subvolid=5 /dev/nvme0n1p2 /mnt/system

# OPTIONAL: IF THIS IS A COMMON PC OR LAPTOP, CREATE A SUBVOLUME FOR USER DATA.  
echo "======================================="
echo "---------------------------------------"
echo "Is this a regular, common device (laptop, personal computer)?"
read -p "If yes, a seperate subvolume for user personal folders will be created to allow easy backups. Select n if this is a server. Y/n?" answer
case ${answer:0:1} in
    y|Y )
# create a root subvolume for user personal folders in the root filesystem
sudo btrfs subvolume create /mnt/system/@userdata
# unmount root filesystem
sudo umount /mnt/system
## Now mount the userdata subvolume, note this will not persist after reboot
sudo mkdir /mnt/userdata
sudo mount -o subvol=@userdata /dev/sda2 /mnt/userdata

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

## Add a commented line in /etc/fstab, user will need to add the UUID
# This makes the /mnt/userdata mount persistent. 
echo "# Mount the BTRFS root subvolume @userdata" | sudo tee -a /etc/fstab
echo "UUID=!!COPY-PASTE-FROM-ABOVE /mnt/userdata           btrfs   defaults,noatime,subvol=@userdata 0       2" | sudo tee -a /etc/fstab

## Now open fstab for the user to copy paste the UUID
echo "==========================================================================================================="
echo "-----------------------------------------------------------------------------------------------------------"
echo "Almost done, now a 2nd window will open and you need to copy/paste with your mouse the UUID from the top"
echo "And paste it where it says !!Copy UUID HERE !!
echo "Then save changes with CTRL+O and exit the file with CTRL+X"
echo "-----------------------------------------------------------------------------------------------------------"
read -p "Are you ready to do this? Hit Enter and enter your password in the 2nd window to open the file."
x-terminal-emulator -e sudo nano /etc/fstab
read -p "When done in the 2nd window, hit ENTER in this window to continue..."
    ;;
    * )
        echo "Not creating userdata, this is not a common personal device." 
    ;;
esac
