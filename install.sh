echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE
echo "Enter STAGE 3 Link"
read STAGE3

SWAP="8G"

sgdisk --zap-all ${DRIVE}
sgdisk -n 1::+256M -t 1:ef00 -c 1:EFI ${DRIVE}
sgdisk -n 2::+${SWAP} -t 2:8200 -c 2:SWAP ${DRIVE}
sgdisk -n 3 -t 3:8300 -c 3:ROOT ${DRIVE}

mkfs.btrfs -f ${DRIVE}${DRIVE_TYPE}"3"
mkfs.vfat -F 32 ${DRIVE}${DRIVE_TYPE}"1"
mkswap ${DRIVE}${DRIVE_TYPE}"2"

swapon ${DRIVE}${DRIVE_TYPE}"2"
mount ${DRIVE}${DRIVE_TYPE}"3" /mnt/gentoo


cd /mnt/gentoo
wget ${STAGE3}
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# UPDATE MAKE.CONF

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

cp /root/ericgentoo/make.conf /mnt/gentoo/etc/portage/make.confs
cp /root/ericgentoo/chroot.sh /mnt/gentoo/

chroot /mnt/gentoo /bin/bash