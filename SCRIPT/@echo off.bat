@echo off
setlocal enabledelayedexpansion

:: Create timestamp
for /f %%i in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set timestamp=%%i

:: Create output folder
set folder=artifacts
if not exist %folder% mkdir %folder%

:: Logcat
adb logcat -d > %folder%\logcat_%timestamp%.txt

:: Dmesg (may be restricted)
adb shell dmesg > %folder%\dmesg_%timestamp%.txt 2>nul


adb shell ps > %folder%\processes_%timestamp%.txt


adb shell pm list packages > %folder%\packages_%timestamp%.txt

(
  echo Model: 
  adb shell getprop ro.product.model
  echo Android Version: 
  adb shell getprop ro.build.version.release
) > %folder%\device_info_%timestamp%.txt

adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png %folder%\screenshot_%timestamp%.png >nul
adb shell rm /sdcard/screenshot.png

pause
