#!/bin/bash

# Create project directory tree
install -d ~/project/ubuntu/{linux,initrd,rootfs,prebuilts,archives/debs,images,utils,scripts}

# Enter the base of project
cd ~/project/ubuntu

# Linux source
if [ ! -d ~/project/ubuntu/linux/.git ]; then
	git clone https://github.com/gouwa/linux-rk3288 linux/
fi

# toolchain
if [ ! -d ~/project/ubuntu/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/.git ]; then
	git clone https://github.com/gouwa/arm-eabi-4.6.git prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/
fi

# initrd source
if [ ! -d ~/project/ubuntu/initrd/.git ]; then
	git clone https://github.com/gouwa/initrd.git initrd/
fi

# hardware packages
if [ ! -d ~/project/ubuntu/archives/hwpacks/.git ]; then
	git clone https://github.com/gouwa/hwpacks.git archives/hwpacks
fi

# ubuntu-core
if [ ! -f ~/project/ubuntu/archives/ubuntu-core-14.04.2-core-armhf.tar.gz ]; then
	wget -P archives/ http://cdimage.ubuntu.com/ubuntu-core/releases/14.04/release/ubuntu-core-14.04.2-core-armhf.tar.gz
fi

# rockchip mkbootimg tools
if [ ! -d ~/project/ubuntu/utils/mkbootimg/.git ]; then
	git clone https://github.com/neo-technologies/rockchip-mkbootimg.git utils/mkbootimg
fi

# rockchip upgrade tools
if [ ! -d ~/project/ubuntu/utils/upgrade/.git ]; then
	git clone https://github.com/gouwa/upgrade_tool.git utils/upgrade
	sudo cp -a utils/upgrade/upgrade_tool /usr/local/bin
	sudo cp -a utils/upgrade/rkflashtool /usr/local/bin
fi

# scripts [option]
if [ ! -d ~/project/ubuntu/scripts/.git ]; then
	git clone https://github.com/gouwa/scripts.git scripts
fi

# build & install mkbootimg
if [ ! -x /usr/local/bin/mkbootimg ]; then
	sudo apt-get install libssl-dev
	make -C utils/mkbootimg/
	sudo make install -C utils/mkbootimg/
fi

# install qemu
if [ ! -x /usr/bin/qemu-arm ]; then
	sudo apt-get install qemu-user-static binfmt-support
fi

# Make sure that all the following packages have been installed
# sudo apt-get install lib32ncurses5-dev lzop bison g++-multilib git gperf libxml2-utils make zlib1g-dev:i386 zip gcc g++ g++-multilib g++-4.8-multilib

echo
echo "Prepare.sh: done time `date`."
