# BTRFS (B-Tree) filesystem allows you to easily create snapshots.
# To exclude folders that are not required when restoring a system snapshot, those folders need to be replaced by BTRFS subvolumes.
# Maybe it makes sense to exclude more system folders. Currently focusing on Ubuntu Budgie 20.10. In my experience only a few should be excluded from a system snapshot. 
#
# The "system" folders that just need to be excluded will be replaced by nested subvolumes.
# Personal data folders that need to be excluded and grouped into a single subvolume will be a subvolume called @userdata in the root of BTRFS, just like @ and @home.
#
# This is the common and recommended way of using BTRFS in a home laptop/pc environment.


# Create nested subvolume for /tmp
cd /
sudo mv /tmp /tmpold
sudo btrfs subvolume create tmp
sudo mv /tmpold/* /tmp
sudo rm -r /tmpold


# Create nested subvolume for $HOME/.cache
cd $HOME
mv ~/.cache ~/.cacheold
btrfs subvolume create .cache
mv .cacheold/* .cache
rm -r .cacheold/


# Create nested subvolume for syncthing database folder 
# If you ever restore a snapshot without excluding the syncthing database, existing files missing in the restored database will be deleted by syncthing!
# if you exclude the syncthing database, it will scan your existing files into a new database. 
cd $HOME/.local/share
mv syncthing stold
btrfs subvolume create syncthing
# add the C attribute to disable Copy-On-Write as this folder contains a database
chattr +C syncthing
mv stold/* syncthing/
rm -r stold


# Create subvolume for personal userdata
sudo mount -o subvolid=5 /dev/nvme0n1p2 /mnt
sudo btrfs subvolume create /mnt/userdata
sudo umount /mnt

# Now mount the subvolume, note this will not persist after reboot
sudo mkdir /mnt/userdata
sudo mount -o subvol=@userdata /dev/nvme0n1p2 /mnt/userdata

# Move personal user folders to the subvolume
# Note I have already moved Desktop and Templates to my Documents folder via my config.sh file.  
sudo mv /home/$LOGNAME/Documents /mnt/userdata/
sudo mv /home/$LOGNAME/Downloads /mnt/userdata/
sudo mv /home/$LOGNAME/Media /mnt/userdata/
sudo mv /home/$LOGNAME/Music /mnt/userdata/
sudo mv /home/$LOGNAME/Photos /mnt/userdata/

# Link personal folders inside subvolume back into home subvolume
ln -s /mnt/userdata/Documents /mnt/home/asterix/Documents
ln -s /mnt/userdata/Downloads /mnt/home/asterix/Downloads
ln -s /mnt/userdata/Media /mnt/home/asterix/Media
ln -s /mnt/userdata/Music /mnt/home/asterix/Music
ln -s /mnt/userdata/Photos /mnt/home/asterix/Photos

# Add a commented line in /etc/fstab, user will need to add the UUID
# This makes the /mnt/userdata mount persistent. 
echo "# Mount the BTRFS root subvolume @userdata" | sudo tee -a /etc/fstab
echo "UUID=!!COPY-PASTE-FROM-ABOVE /mnt/userdata           btrfs   defaults,noatime,subvol=@userdata 0       2" | sudo tee -a /etc/fstab

# Now open fstab for the user to copy paste the UUID
sudo nano /etc/fstab
