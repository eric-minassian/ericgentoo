#!/bin/bash

lsblk
echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE
echo "Enter Swap Size"
read SWAP
echo "PC (ENTER) or VM (v)"
read DEVICE
echo "Hostname"
read HOSTNAME
echo "Enter Username"
read USERNAME
ifconfig
echo "Enter Network Interface"
read INTERFACE



wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/install.sh
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/make.conf
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/make_vm.conf
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/post.sh
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/chroot2.sh
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/chroot1.sh
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/.config
wget https://raw.githubusercontent.com/eric-minassian/ericgentoo/main/package.accept_keywords


chmod +x chroot1.sh
chmod +x chroot2.sh
chmod +x install.sh
chmod +x post.sh
./install.sh $DRIVE $DRIVE_TYPE $SWAP $DEVICE $HOSTNAME $USERNAME $INTERFACE