#!/bin/bash

# Enter the root directory
cd ~/project/ubuntu

# Create a blank image file
dd if=/dev/zero of=images/rootfs.img bs=1M count=0 seek=2560

# Create linux filesystem
mkfs.ext4 -F -L linuxroot images/rootfs.img

# Confirm that rootfs is an empty directory
rm -rf rootfs && install -d rootfs

# Loop mount and remove the unnecessary files
sudo mount -o loop images/rootfs.img rootfs
sudo rm -rf rootfs/lost+found

# Extract the ubuntu-core tarball
sudo tar xzf archives/ubuntu-core-14.04.2-core-armhf.tar.gz -C rootfs/

# Add hardware packages
sudo cp -a archives/hwpacks/system/ rootfs/

# Add Mali support
sudo sed -i '/^exit 0/i/sbin/insmod /system/lib/modules/mali_kbase.ko' rootfs/etc/rc.local

# Add wifi & bt support
sudo cp archives/hwpacks/wifibt/wifion rootfs/usr/local/bin/
sudo cp archives/hwpacks/wifibt/wifioff rootfs/usr/local/bin/
sudo cp archives/hwpacks/wifibt/*.conf rootfs/etc/init

# Chroot
sudo cp /usr/bin/qemu-arm-static rootfs/usr/bin/
sudo modprobe binfmt_misc
sudo mount -t devpts devpts rootfs/dev/pts
sudo mount -t devpts devpts rootfs/proc
echo
echo "NOTE: YOU ARE NOW IN THE VIRTUAL TARGET, SETUP ANYTHING YOU WANT."
echo "      WHEN YOU FINISH, TYPE exit TO CONTINUE."
sudo chroot rootfs/

# Unmount
sync
sudo umount rootfs/proc
sudo umount rootfs/dev/pts
sudo umount rootfs

echo
echo "rootfs: done time `date`."
