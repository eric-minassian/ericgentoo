echo "Enter Username"
read USERNAME

cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
useradd -m -G users,wheel,audio -s /bin/bash ${USERNAME}
passwd ${USERNAME}