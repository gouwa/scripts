#!/bin/bash

# Enter the root directory
cd ~/project/ubuntu

# Compile the kernel
make -C linux rockchip_box_linux_defconfig
make -C linux rk3288-box.img -j8
cp linux/resource.img images/

# Compile the initrd
make -C initrd

# Build the boot.img
mkbootimg --kernel linux/arch/arm/boot/zImage --ramdisk images/initrd.img -o images/boot.img


echo
echo "boot.sh: done time `date`."

