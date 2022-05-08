#!/bin/bash

sed -i -e '$a\' file

echo 
echo "______________________________________________________/"
echo "_____________________________________________________/oo"
echo "____________________________________________________/oooo"
echo "___________________________________________________/oooooo"
echo "__________________________________________________'oooooooo"
echo "_________________________________________________/-'oooooooo"
echo "________________________________________________/00-'oooooooo"
echo "_______________________________________________/0000o'oooooooo"
echo "______________________________________________/0000000ooooooooo"
echo "_____________________________________________/000000000ooooooooo"
echo "____________________________________________/0000000'____'ooooooo"
echo "___________________________________________/0000000_______:ooooooo"
echo "__________________________________________/00000000________oooooooo"
echo "_________________________________________/00000000,________.oooooooo"
echo "________________________________________/000007^______________^oooooo"
echo "_______________________________________/0007^____________________^oooo"
echo "______________________________________/po^__________________________^oq"
echo 
echo " L i n u x  A r c h  64bit  PCdesk   m a i n  s i t e  : archlinux.org"
echo " ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
echo " Marco Colonna  akaTOVOT  29/03/82   email :   arbitrio@altervista.com"
echo " ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
echo 

# temporary setup of keyboard layout

read -p "[ temp ] keyboard layout: " KEYL && loadkeys $KEYL

# temporary clock syncronization

echo "[ temp ] clock syncronization" && timedatectl set-ntp true

# tools for partitioning

PS3='[ menu ] choose partition tool (1) status (2) fdisk (3) cfdisk (4) continue: '
optsp=("status" "fdisk" "cfdisk" "continue") 
select opt in "${optsp[@]}"
do
    case $opt in
        "status")
            fdisk -l
            ;;
        "fdisk")
            fdisk /dev/sda
            ;; 
        "cfdisk")
            cfdisk
            ;;
        "continue")
            break
            ;;
        *) echo "invalid option $REPLY"
            ;;
    esac 
done

# mounting

echo "[ .... ]" mkdir /mnt/boot
echo "[ .... ]" mount /dev/sda1 /mnt/boot
echo "[ .... ]" mount /dev/sda3 /mnt

# base packages, fstab, chroot

echo "[ .... ]" pacstrap /mnt base base-devel
echo "[ .... ]" genfstab -U /mnt >> /mnt/etc/fstab
echo "[ .... ]" arch-chroot /mnt
echo "[ .... ]" pacman -S nano dhcpcd dbus-broker

# time zone, hardware clock

echo "[ .... ]" 
echo "[ .... ]" 
