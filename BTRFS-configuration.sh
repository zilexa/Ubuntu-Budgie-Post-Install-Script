# BTRFS (B-Tree) filesystem doesn't let you create snapshots if there is a working swap file on the subvolume. 
# That means that it is highly recommended to place a swap file on a separate subvolume.

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

# Move personal user folders to the subvolume
sudo mv /home/$LOGNAME/Documents /mnt/@userdata/
sudo mv /home/$LOGNAME/Downloads /mnt/@userdata/
sudo mv /home/$LOGNAME/Media /mnt/@userdata/
sudo mv /home/$LOGNAME/Music /mnt/@userdata/
sudo mv /home/$LOGNAME/Photos /mnt/@userdata/

# Link personal folders inside subvolume back into home subvolume
ln -s /mnt/@userdata/Documents /mnt/@home/asterix/Documents
ln -s /mnt/@userdata/Downloads /mnt/@home/asterix/Downloads
ln -s /mnt/@userdata/Media /mnt/@home/asterix/Media
ln -s /mnt/@userdata/Music /mnt/@home/asterix/Music
ln -s /mnt/@userdata/Photos /mnt/@home/asterix/Photos

# Unmount the BTRFS root
sudo umount /mnt
