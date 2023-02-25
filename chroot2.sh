echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE
echo "Hostname"
read HOSTNAME
echo "Enter Username"
read USERNAME
ifconfig
echo "Enter Network Interface"
read INTERFACE


cat << EOF > /etc/fstab
${DRIVE}${DRIVE_TYPE}1	/boot	vfat	defaults,noatime	0 2
${DRIVE}${DRIVE_TYPE}2	none	swap	sw			0 0
${DRIVE}${DRIVE_TYPE}3	/		btrfs	noatime		0 1
EOF

echo "${HOSTNAME}" > /etc/hostname

emerge -q net-misc/dhcpcd net-misc/netifrc
rc-update add dhcpcd default
rc-service dhcpcd start
echo "config_${INTERFACE}='dhcp'" > /etc/conf.d/net
cd /etc/init.d
ln -s net.lo net.${INTERFACE}
rc-update add net.${INTERFACE} default

echo 'clock="local"' > /etc/conf.d/hwclock
echo 'clock_args=""' >> /etc/conf.d/hwclock

rc-update add sshd default

emerge -q sys-fs/btrfs-progs sys-boot/grub app-admin/doas app-misc/neofetch net-misc/chrony dev-vcs/git

rc-update add chronyd default

echo "permit :wheel" > /etc/doas.conf

passwd
useradd -m -G users,wheel,audio -s /bin/bash ${USERNAME}
passwd ${USERNAME}

grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

rm /stage3-*.tar.*