#!/bin/bash
echo 
echo "                                                      /"
echo "                                                     /oo"
echo "                                                    /oooo"
echo "                                                   /oooooo"
echo "                                                  'oooooooo"
echo "                                                 /-'oooooooo"
echo "                                                /00-'oooooooo"
echo "                                               /0000o'oooooooo"
echo "                                              /0000000ooooooooo"
echo "                                             /000000000ooooooooo"
echo "                                            /0000000'    'ooooooo"
echo "                                           /0000000       .ooooooo"
echo " ▀       ▀ ▀   ▀   ▀ ▀ ▀  ▀ ▀ ▀ ▀ ▀       /00000000        oooooooo"
echo "  ▀     ▀ ▀ ▀ ▀ ▀ ▀     ▀ ▀ ▀      ▀     /00000000,        .oooooooo"
echo "   ▀   ▀  ▀  ▀  ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀ ▀     /000007^              ^oooooo"
echo "    ▀ ▀   ▀     ▀ ▀     ▀ ▀ ▀      ▀   /0007^                    ^oooo"
echo "     ▀    ▀     ▀ ▀     ▀ ▀ ▀ ▀ ▀ ▀   /po^                          ^oq"
echo "                                                                       "
echo "      V e r y   M i n i m a l   A r c h   I n s t a l l   B a s e      "
echo "                                                                       "
echo " A r c h L i n u x   6 4 bit   b a s h   s c r i p t   semi ─ automata "
echo "                                                                       "
echo " Marco Colonna  aka TOVOT  29─03─1982  email : arbitrio@altervista.com "
echo " _____________________________________________________________________ "
echo 

# for debug add after any command you want debug: -p "press enter to continue"

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

echo "[ temp ] clock syncronization" && timedatectl set-ntp true
echo 
read -p "press enter to continue" # find how to wait all output from timedatectl before continue
echo 

# partitioning tools

echo "[ info ] partition configuration follows"
echo "[ info ] the script work with this table"
echo "[ info ] $DRIVE 1 as boot"
echo "[ info ] $DRIVE 2 as swap"
echo "[ info ] $DRIVE 3 as main"
echo 
read -p "press enter to continue"
echo 

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
echo 

# mounting

echo "[ work ] mkdir /mnt/boot" && mkdir /mnt/boot
echo "[ work ] mount /dev/sda1 /mnt/boot" && mount /dev/sda1 /mnt/boot # missing UEFI alternative
echo "[ work ] mount /dev/sda3 /mnt" && mount /dev/sda3 /mnt
echo 

# minimal packages, genfstab, entering chroot

echo "[ work ] install minimal packages" && pacstrap /mnt base base-devel nano dhcpcd dbus-broker
echo "[ work ] genfstab" && genfstab -U /mnt >> /mnt/etc/fstab
echo "[ work ] arch-chroot"
#cp -R /temp-git /mnt                                   # git
#arch-chroot /mnt "bash /temp-git/vmaib/vmaibcr.sh"
cp -R /shared /mnt                                      # VirtualBox
arch-chroot /mnt "bash /shared/vmaibcr.sh"

# switch to vmaibcr.sh
