@echo off
color F0
title Sizeify
setlocal enabledelayedexpansion
cd resources
goto mainscr

:mainscr
cls
echo Select drive.
cmdMenuSel F08F "Opcja 1" "Opcja 2" "Opcja 2"
if %ERRORLEVEL% == 1 goto opcja1
if %ERRORLEVEL% == 2 goto opcja2
if %ERRORLEVEL% == 3 goto opcja3
goto mainscr

:opcja1
mkdosfs -n %NAME% -v %letter%: 8386900