#!/bin/bash
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
echo "___________________________________________/0000000_______.ooooooo"
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

# auto configuration from script

DRIVE='/dev/sda'
HOSTNAME='PCdesk'
USERNAME='tovot'
TIMEZONE='Europe/Rome'
LANGUAGE='en_US.UTF-8'
LOCALE='en_US.UTF-8 UTF-8'
KEYMAP='it'

# temporary setup keyboard layout

# if setting manual comment auto configuration from script (and viceversa)
#read -p "[ temp ] keyboard layout: " KEYMAP && loadkeys $KEYMAP
echo "[ temp ] keyboard layout" && loadkeys $KEYMAP

# temporary clock syncronization

echo "[ temp ] clock syncronization" && timedatectl set-ntp true # find how wait all output before continue
echo 
read -p "press enter to continue"
echo 

# partitioning tools

echo "[ info ] partition configuration follows"
echo "[ info ] the script work with this table"
echo "[ info ] $DRIVE 1 as boot"
echo "[ info ] $DRIVE 2 as swap"
echo "[ info ] $DRIVE 3 as main"
read -p "press enter to continue"

# big help from here: https://unix.stackexchange.com/questions/701843/how-to-bash-script-menu-in-one-row-only

PS3='[ menu ] choose partition tool '
options=("status" "fdisk" "cfdisk" "continue")
while :
do
    printf '%s' "$PS3"
    for ((i = 0; i < ${#options[@]}; i++))
    do
        printf ' (%d) %s' $((i+1)) "${options[i]}"
    done
    
    read -p ': ' opt
    case "$opt" in
        1|"status")
            fdisk -l
            ;;
        2|"fdisk")
            fdisk $DRIVE
            ;;
        3|"cfdisk")
            cfdisk
            ;;
        4|"continue")
            break
            ;;
        *) echo "invalid option $opt"
            ;;
    esac
done
echo 

# formatting, swapon

echo "[ work ] format partition boot" && mkfs.ext2 /dev/sda1
#echo "[ work ] format partition boot" && mkfs.fat -F32 /dev/sda1 # UEFI
echo "[ work ] format partition main" && mkfs.ext4 /dev/sda3
echo "[ work ] format partition swap" && mkswap /dev/sda2
echo "[ work ] activate swap" && swapon /dev/sda2
read -p "press enter to continue"
echo 

# mounting

echo "[ work ] mkdir /mnt/boot" && mkdir /mnt/boot
echo "[ work ] mount /dev/sda1 /mnt/boot" && mount /dev/sda1 /mnt/boot # missing UEFI alternative
echo "[ work ] mount /dev/sda3 /mnt" && mount /dev/sda3 /mnt
read -p "press enter to continue"
echo 

# minimal packages, genfstab, entering chroot

echo "[ work ] install minimal packages" && pacstrap /mnt base base-devel nano dhcpcd dbus-broker
echo "[ work ] genfstab" && genfstab -U /mnt >> /mnt/etc/fstab
echo "[ work ] arch-chroot" && cp -R /temp-git /mnt && arch-chroot /mnt { "bash /temp-git/vmaibcr.sh" }

# switch to vmaibcr.sh
