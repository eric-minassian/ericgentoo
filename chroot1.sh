echo "Enter Drive Name"
read DRIVE
echo "Hard Drive (Enter) or NVME (p)"
read DRIVE_TYPE

source /etc/profile
export PS1="(chroot) ${PS1}"

mount ${DRIVE}${DRIVE_TYPE}"1" /boot
emerge-webrsync
eselect profile list
echo "What Number"
read PROFILE_NUMBER
eselect profile set ${PROFILE_NUMBER}

emerge --verbose --update --deep --newuse @world

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

echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license
emerge -q sys-kernel/linux-firmware sys-kernel/gentoo-sources

eselect kernel list
echo "What Number"
read KERNEL_NUMBER
eselect kernel set ${KERNEL_NUMBER}

emerge -q sys-apps/pciutils
