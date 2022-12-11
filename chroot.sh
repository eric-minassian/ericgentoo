echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE
echo "Hostname"
read HOSTNAME
ifconfig
echo "IF NAME"
read IF_NAME

source /etc/profile
export PS1="(chroot) ${PS1}"

mount ${DRIVE}${DRIVE_TYPE}"1" /boot
emerge-webrsync
eselect profile list
echo "What Number"
read PROFILE_NUMBER
eselect profile set ${PROFILE_NUMBER}

emerge --verbose --update --deep --newuse @world

emerge app-portage/cpuid2cpuflags
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

echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license
emerge sys-kernel/linux-firmware sys-kernel/gentoo-sources

# eselect kernel list
# echo "What Number"
# read KERNEL_NUMBER
# eselect kernel set ${KERNEL_NUMBER}
eselect kernel set 1

emerge sys-apps/pciutils sys-kernel/gentoo-kernel-bin
emerge --depclean

cat << EOF > /etc/fstab
${DRIVE}${DRIVE_TYPE}1	/boot	vfat	defaults,noatime	0 2
${DRIVE}${DRIVE_TYPE}2	none	swap	sw		0 0
${DRIVE}${DRIVE_TYPE}3	/		btrfs	noatime	0 1
EOF

echo "hostname='${HOSTNAME}'" > /etc/conf.d/hostname

emerge net-misc/dhcpcd net-misc/netifrc
rc-update add dhcpcd default
rc-service dhcpcd start
echo "config_${IF_NAME}='dhcp'"
cd /etc/init.d
ln -s net.lo net.${IF_NAME}
rc-update add net.${IF_NAME} default

passwd

rc-update add sshd default
# emerge net-misc/chrony
# rc-update add chronyd default

emerge sys-fs/btrfs-progs sys-boot/grub

grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
exit