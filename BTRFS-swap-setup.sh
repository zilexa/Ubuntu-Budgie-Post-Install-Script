# BTRFS (B-Tree) filesystem doesn't let you create snapshots if there is a working swap file on the subvolume. 
# That means that it is highly recommended to place a swap file on a separate subvolume.
#
# When selecting BTRFS as filesystem during Ubuntu or Debian setup, the swapfile is not created. 

# Assuming / is on /dev/nvme0n1p2 and Ubuntu is installed with / on @ subvolume and /home is on @home subvolume.
# This is by default, if you didn't deviate from default setup after choosing BTRFS. 
# Note /dev/nvme0n1p1 is the boot partition. Ignore it. 

# Mount /dev/nvme0n1p2 to /mnt.
sudo mount /dev/nvme0n1p2 /mnt

# Optional: If you run ls /mnt, you'll see @, @home and other subvolumes that may be there.

# Create a new @swap subvolume.
sudo btrfs sub create /mnt/@swap

# Unmount /dev/sda1 from /mnt
sudo umount /mnt

# Create /swap directory where we plan to mount the @swap subvolume.
sudo mkdir /swap

# Mount the @swap subvolume to /swap.
sudo mount -o subvol=@swap /dev/nvme0n1p2 /swap

# Create the swap file.
sudo touch /swap/swapfile

# Set 600 permissions to the file.
sudo chmod 600 /swap/swapfile

# Disable COW for this file.
sudo chattr +C /swap/swapfile

# Set size of the swap file to 4G as an example.
sudo fallocate /swap/swapfile -l4g

# Format the swapfile
sudo mkswap /swap/swapfile

# Turn the swap file on.
sudo swapon /swap/swapfile

# Add a template to etc/fstab, user needs to set the UUID using sudo nano /etc/fstab
sudo echo '#swap subvolume !!! CHANGE THE UUID TO THE ONE OF nvme01p2 ABOVE!!!!' >> /etc/fstab
sudo echo 'UUID=XXXXXXXXXXXXXXX /swap btrfs defaults,noatime,subvol=@swap 0 0' >> /etc/fstab
sudo echo '#swap file 
sudo echo '/swap/swapfile none swap sw 0 0' >> /etc/fstab
