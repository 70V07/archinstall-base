> [!NOTE]
> this repository it is abandoned to the cosmic void, in the sense that I have not continued this experiment...

## Very Minimal Arch Install Base ( currently malfunctioning and incomplete )

**! public just to bypass authentication** ─ its just a simple script for install Arch Linux ready with very minimal configuration and ethernet Internet access, whitout graphical interface; this bash script install those packages only:
```
base, base-devel, grub, os-prober, nano, dhcpcd, dbus-broker, linux-headers, git, sudo, trizen
```

*files is in constant change (I strike this when I finish the changes)*

*I do not take any responsibility (it is for didactic personal purphoses)*

*for those who want to try the script, from shell (in Arch live medium):*
```
cd / && mkdir temp-git && cd temp-git && pacman -Sy git
  
git clone https://github.com/70V07/vmaib.git && cd vmaib

bash vmaib.sh
```
