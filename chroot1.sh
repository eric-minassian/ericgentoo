#!/bin/bash

DRIVE=$1
DRIVE_TYPE=$2
SWAP=$3
DEVICE=$4
HOSTNAME=$5
USERNAME=$6
INTERFACE=$7

source /etc/profile
export PS1="(chroot) ${PS1}"

mount ${DRIVE}${DRIVE_TYPE}"1" /boot
emerge-webrsync -q
eselect profile list
echo "What Number"
read PROFILE_NUMBER
eselect profile set ${PROFILE_NUMBER}

emerge -q --update --deep --newuse @world

emerge -q app-portage/cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags

echo "America/Los_Angeles" > /etc/timezone
emerge --config sys-libs/timezone-data
sed -i 's/#en_US/en_US/' /etc/locale.gen
locale-gen

eselect locale list
echo "What Number"
read LOCALE_NUMBER
eselect locale set ${LOCALE_NUMBER}

env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

rm -rf /etc/portage/package.accept_keywords/
mv /package.accept_keywords /etc/portage/

echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license
emerge -q sys-kernel/linux-firmware sys-kernel/installkernel-gentoo sys-kernel/gentoo-kernel sys-kernel/gentoo-sources

eselect kernel list
echo "What Number"
read KERNEL_NUMBER
eselect kernel set ${KERNEL_NUMBER}

./chroot1.sh $DRIVE $DRIVE_TYPE $SWAP $DEVICE $HOSTNAME $USERNAME $INTERFACE
