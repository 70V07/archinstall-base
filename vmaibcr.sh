#!/bin/bash

# for debug add after any command you want debug: -p "press enter to continue"

# time zone, hardware clock

echo "[ work ] setup time zone" && ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "[ work ] syncronize hardware time" && hwclock --systohc
echo "[ show ] system time" && timedatectl show
echo "[ show ] hardware time" && hwclock --show
echo #pause here and add find how tabs before all outpouts on last 2 commands

# locale, keymap

echo "[ work ] locale" && sed -i "/^#$LOCALE/ c$LOCALE" /etc/locale.gen
echo "[ work ] locale" && locale-gen
echo "[ work ] locale" && echo LANG=$LANGUAGE > /etc/locale.conf
echo 

# hostname, password

echo "[ work ] hostname" && echo $HOSTNAME > /etc/hostname
echo -n "[ work ] ROOT ─ " && passwd root
echo 

# boot loader

# if UEFI uncomment not-UEFI (and viceversa)
echo "[ work ] boot" && pacman -S grub os-prober
#echo "[ work ] boot" && pacman -S grub efibootmgr # UEFI
echo "[ work ] boot" && grub-install $DRIVE
#echo "[ work ] boot" && grub-install --efi--directory=/efi # UEFI
echo "[ work ] boot" && grub-mkconfig -o /boot/grub/grub.cfg
echo

echo "now reboot and bypass or disconnect installation support"
echo "first exit from chroot, for exit from chroot type:  exit"
echo "after the reboot clone again VMAIB "
echo
