::SIZEIFY BY REVOX 2019
::FEEL FREE TO USE PARTS OF THE CODE, IF YOU DO IT WOULD BE NICE TO GIVE CREDITS TO ME AND THIS REPO :)
::startup stuff
@echo off
color F0
title Sizeify alpha 1b by revox
set array=0
cd %~dp0
setlocal EnableDelayedExpansion
cd resources
goto drivescr

:drivescr
cls
echo Select the drive you want to extend
echo 	Available drives:
::use wmic to get available drives and save them to a file:
for /f "tokens=2 delims==" %%d in ('wmic logicaldisk get name /format:value') do echo %%d >drives.ini
::parse values from the file:
set/p array=< drives.ini
set a=%array:~0,5%
set b=%array:~2,2%
set c=%array:~5,2%
set d=%array:~7,2%
set e=%array:~9,2%
set f=%array:~11,2%
del drives.ini
::create a selection screen using previously saved sets:
cmdMenuSel F08F "%a%" "%b%" "%c%" "%d%" "%e%" "%f%"
if %ERRORLEVEL% == 1 set driveltr=%a%
if %ERRORLEVEL% == 2 set driveltr=%b%
if %ERRORLEVEL% == 3 set driveltr=%c%
if %ERRORLEVEL% == 4 set driveltr=%d%
if %ERRORLEVEL% == 5 set driveltr=%e%
if %ERRORLEVEL% == 6 set driveltr=%f%
goto confirmdrive

:confirmdrive
cls
echo You have selected drive %driveltr%
echo	Is this correct?
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 goto labelscr
if %ERRORLEVEL% == 2 goto drivescr
goto confirmdrive

:labelscr
::set default drive label if user doesn't want a custom one
set drivelbl=New drive
cls
echo Would you like to add a custom label to drive?
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 goto labelscr-label
if %ERRORLEVEL% == 2 goto extendscr
goto labelscr

:labelscr-label
cls
echo Type label you want and press enter
:: i used ccolor to make input combine better with rest of the UI (gray instead of black)
ccolor F8 /p ='Label: '
set/p drivelbl=Label: 
ccolor F0 /p ='Label: '
goto confirmlabel

:confirmlabel
cls
echo You want the drive to be labeled "%drivelbl%"
echo	Is this correct?
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 goto extendscr
if %ERRORLEVEL% == 2 goto labelscr-label
goto confirmlabel

:extendscr
cls
echo You are all ready to extend the drive.
echo 	Is the information correct?
echo.
echo    Drive letter: %driveltr%
echo    Drive label: %drivelbl%
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 goto extend-confirm
if %ERRORLEVEL% == 2 goto drivescr

:extend-confirm
cls
echo The following proccess will wipe all data
echo from your USB drive. Make a backup first.
echo 	Do you want to continue?
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 goto extend
if %ERRORLEVEL% == 2 goto drivescr

:extend
cls
echo Please wait...
::we use mkdosfs windows port in order to increase the drive capacity, which will extend it visually to 4gb
::even though it won't be possible to use all 4gb without data corruption,
::it's gonna shift registers and allow to copy a few dozens MB more.
::we also save mkdosfs log to file in order to identify problems
timeout 1 >nul
mkdosfs -n "%drivelbl%" -v %driveltr% 8386900
::we use errorlevel to dermine if action has been successfully completed
IF ERRORLEVEL 0 goto finishscr
IF ERRORLEVEL 1 goto failscr
goto finishscr

:finishscr
cls
echo 	Thanks for using Sizeify by revox.
echo The drive has been successfully extended.
echo Be aware, that it will visually show as 4gb
echo But you will only recieve ~80mb more to use.
echo 	Do you want to extend another drive?
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 drivescr
if %ERRORLEVEL% == 2 exit
goto finishscr

:failscr
echo An error occured. Make sure your drive isn't
echo write-protected. You can try again if you believe
echo it was just a program bug.
echo 	Do you want to try again?
cmdMenuSel F08F "Yes" "No"
if %ERRORLEVEL% == 1 drivescr
if %ERRORLEVEL% == 2 exit
goto failscr
