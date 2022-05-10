
## Very Minimal Arch Install Base

###### ! public just to bypass authentication

its a simple script for install Arch Linux whit those packages only:
```
base, base-devel, grub, os-prober, nano, dhcpcd, dbus-broker, linux-headers, git, sudo, trizen
```
ready with minimal configuration and ethernet Internet acces, whitout graphical interface.

*I do not take any responsibility (it is for didactic personal purphoses)*

**files is in constant change (I strike this when I finish the changes)**

**for those who want to try the script, from shell (in Arch live medium):**
```
cd \ && mkdir temp-git && cd temp-git && pacman -Sy git
  
git clone https://github.com/70V07/vmaib.git && vmaib.sh
```
