host=$1

set -e

r=`make kernelrelease`

rm -rf myinstall
make modules_install INSTALL_MOD_PATH=myinstall
make install INSTALL_PATH=myinstall

tar -C myinstall -cz lib | ssh $host tar  -xz -C /
tar -C myinstall -cz vmlinuz-$r | ssh $host tar -xz -C /boot
ssh $host mkinitrd --force /boot/initramfs-$r.img $r
ssh $host kexec -l /boot/vmlinuz-$r --initrd=/boot/initramfs-$r.img --reuse-cmdline
ssh $host systemctl kexec

