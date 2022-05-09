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
echo 

# temporary clock syncronization

echo "[ temp ] clock syncronization" && timedatectl set-ntp true
echo 

# partitioning tools

echo "[ info ] partition configuration follows"
echo "[ info ] the script work with this table"
echo "[ info ] $DRIVE 1 as boot"
echo "[ info ] $DRIVE 2 as swap"
echo "[ info ] $DRIVE 3 as main"
read -p "Press enter to continue"

# big help from here: https://unix.stackexchange.com/questions/701843/how-to-bash-script-menu-in-one-row-only

PS3='[ menu ] choose partition tool (1) status (2) fdisk (3) cfdisk (4) continue: '
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

# mounting

echo "[ work ] mkdir /mnt/boot" && mkdir /mnt/boot
echo "[ work ] mount /dev/sda1 /mnt/boot" && mount /dev/sda1 /mnt/boot # missing UEFI alternative
echo "[ work ] mount /dev/sda3 /mnt" && mount /dev/sda3 /mnt
echo 

# base packages, fstab, chroot

echo "[ work ] install base packages" && pacstrap /mnt base base-devel
echo "[ work ] genfstab" && genfstab -U /mnt >> /mnt/etc/fstab
echo "[ work ] arch-chroot" && arch-chroot /mnt
echo "[ work ] install editor and network utility" && pacman -S nano dhcpcd dbus-broker
echo 

# time zone, hardware clock

echo "[ work ] setup time zone" && ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "[ work ] syncronize hardware time" && hwclock --systohc
echo "[ show ] system time" && timedatectl show
echo "[ show ] hardware time" && hwclock --show
echo 

# locale, keymap

echo "[ work ] locale" && sed -i "/^#$LOCALE/ c$LOCALE" /etc/locale.gen
echo "[ work ] locale" && locale-gen
echo "[ work ] locale" && echo LANG=$LANGUAGE > /etc/locale.conf
echo "[ work ] keymap" && echo KEYMAP=$KEYMAP > /etc/vconsole.conf
echo 

# hostname, password

echo "[ work ] hostname" && echo $HOSTNAME > /etc/hostname
echo -n "[ work ] USER ─ " && passwd $USERNAME
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

echo now reboot and bypass or disconnect installation support
echo
