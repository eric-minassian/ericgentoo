echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE
echo "Hostname"
read HOSTNAME
ifconfig
echo "IF NAME"
read IF_NAME
echo "Enter Username"
read USERNAME


cat << EOF > /etc/fstab
${DRIVE}${DRIVE_TYPE}1	/boot	vfat	defaults,noatime	0 2
${DRIVE}${DRIVE_TYPE}2	none	swap	sw			0 0
${DRIVE}${DRIVE_TYPE}3	/		btrfs	noatime		0 1
EOF

echo "hostname='${HOSTNAME}'" > /etc/conf.d/hostname

emerge -q net-misc/dhcpcd net-misc/netifrc
rc-update add dhcpcd default
rc-service dhcpcd start
echo "config_${IF_NAME}='dhcp'" > /etc/conf.d/net
cd /etc/init.d
ln -s net.lo net.${IF_NAME}
rc-update add net.${IF_NAME} default

rc-update add sshd default

emerge -q sys-fs/btrfs-progs sys-boot/grub app-admin/doas app-misc/neofetch

echo "permit :wheel" > /etc/doas.conf

passwd
useradd -m -G users,wheel,audio -s /bin/bash ${USERNAME}
passwd ${USERNAME}

grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
