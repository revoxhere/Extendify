#!/bin/bash
#EXTENDIFY FOR LINUX BY REVOX 2019
#FEEL FREE TO USE PARTS OF THE CODE, IF YOU DO IT WOULD BE NICE TO GIVE CREDITS TO ME AND THIS REPO :)
#This version is less advanced than windows version - you can only do basic stuff about drive.

#we add goto function to make my life a bit easier :P
function goto
{
    label=$1
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | 
          grep -v ':$')
    eval "$cmd"
    exit
}

#main menu
: selectscr
clear
echo Extendify version 2c by revox
echo  What do you want to do?
echo 1 - Extend capacity of a removable drive 
echo 2 - Restore original capacity of a removable drive
read -r -p " 	 [1/2] " response
case "$response" in
    [1]|[2)
        goto drivescr
        ;;
    *)
		goto restorescr
esac

: restorescr
clear
echo  Enter path to drive you want to restore capacity [e.g. /dev/mspblk0]
read -p "	 Drive: " driveltr
clear
echo  You have selected drive $driveltr
read -r -p " 	 Is this correct? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto confirmrestore
        ;;
    *)
		goto restorescr
esac

: confirmrestore
clear
echo	 The drive will be reset to its orignal capacity
echo  Be aware that this process will erase all data [format it]!
echo  Please make a backup of your data first.
echo   Your system may also become unstable for a few seconds.
read -r -p " 	 Continue? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto rmain
        ;;
    *)
		goto selectscr
esac

#we prompt for drive and check if it's correct
: drivescr
clear
echo  Enter path to drive you want to extend [e.g. /dev/mspblk0]
read -p "	 Drive: " driveltr
clear
echo  You have selected drive $driveltr
read -r -p " 	 Is this correct? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto labelscr
        ;;
    *)
		goto drivescr
esac

#we prompt for drive label and check if it's correct
: labelscr
clear
echo  Enter label the drive should be named [e.g. My drive]
read -p "	 Label: " drivelbl
clear
echo  You have entered label "$drivelbl"
read -r -p " 	 Is this correct? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto extendscr
        ;;
    *)
		goto labelscr
esac

#we display some warnings
: extendscr
clear
echo   You are all ready to extend the drive.
echo   The following proccess will wipe all data
echo   from your USB drive. Make a backup first.
echo   Your system may also become unstable for a few seconds.
read -r -p " 	 Continue? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto main
        ;;
    *)
		goto drivescr
esac

#we use mkdosfs in order to increase the drive capacity, which will extend it visually to 4gb
#even though it won't be possible to use all 4gb without data corruption,
#it's gonna shift registers and allow to copy a few dozens MB more.
: main
clear
echo  Please wait...
sudo umount $driveltr
sudo mkdosfs -n "$drivelbl" $driveltr 4386900 -I -v
sudo udevadm trigger
ping localhost -q -c 3 >.nul 
goto finishscr

: rmain
clear
echo  Please wait...
sudo umount $driveltr
sudo mkdosfs -n "NEW DRIVE" $driveltr 4386900 -I -v
sudo udevadm trigger
ping localhost -q -c 3 >.nul 
goto restorefinish

: restorefinish
clear
echo   	     Thanks for using Extendify.
echo  The drive has been successfully restored
echo  to its original capacity.
read -r -p " 	 Do you want to go back to main menu? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto selectscr
        ;;
    *)
esac

#we display end-screen
: finishscr
clear 
echo   	     Thanks for using Extendify.
echo  The drive has been successfully extended.
echo  Be aware, that it will visually show as 4gb
echo  But you will only recieve ~80mb more to use.
read -r -p " 	 Do you want to extend another drive? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        goto drivescr
        ;;
    *)
esac