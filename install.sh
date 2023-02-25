echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE
# echo "Enter STAGE 3 Link"
# read STAGE3
echo "Enter Swap Size"
read SWAP
echo "PC (ENTER) or VM (v)"
read DEVICE

STAGE3="https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20230220T081656Z/stage3-amd64-openrc-20230220T081656Z.tar.xz"

# Partition Drive
sgdisk --zap-all ${DRIVE}
sgdisk -n 1::+256M -t 1:ef00 -c 1:EFI ${DRIVE}
sgdisk -n 2::+${SWAP} -t 2:8200 -c 2:SWAP ${DRIVE}
sgdisk -n 3 -t 3:8300 -c 3:ROOT ${DRIVE}

# Format Drive
mkfs.btrfs -f ${DRIVE}${DRIVE_TYPE}"3"
mkfs.vfat -F 32 ${DRIVE}${DRIVE_TYPE}"1"
mkswap ${DRIVE}${DRIVE_TYPE}"2"

swapon ${DRIVE}${DRIVE_TYPE}"2"
mount ${DRIVE}${DRIVE_TYPE}"3" /mnt/gentoo


cd /mnt/gentoo
wget ${STAGE3}
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner


mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run


if [ "$DEVICE" = "v" ]; then
    cp /root/make_vm.conf /mnt/gentoo/etc/portage/make.conf
else
    cp /root/make.conf /mnt/gentoo/etc/portage/make.conf
fi

cp /root/chroot1.sh /mnt/gentoo/
cp /root/chroot2.sh /mnt/gentoo/
cp /root/.config /mnt/gentoo/
cp /root/package.accept_keywords /mnt/gentoo/


chroot /mnt/gentoo /bin/bash 