@echo off
setlocal

echo ============================================
echo Installing NVM for Windows and Node.js (LTS)
echo ============================================

:: Set download info for NVM
set "NVM_VERSION=1.1.12"
set "NVM_URL=https://github.com/coreybutler/nvm-windows/releases/download/%NVM_VERSION%/nvm-setup.exe"
set "NVM_SETUP=%TEMP%\nvm-setup.exe"
set "SHORTCUT_NAME=Node.js (via NVM).lnk"
set "DESKTOP_PATH=%Public%\Desktop"

:: Download NVM installer
echo Downloading NVM installer...
powershell -Command "Invoke-WebRequest -Uri '%NVM_URL%' -OutFile '%NVM_SETUP%'"

:: Install NVM with UI
echo Installing NVM...
start /wait "" "%NVM_SETUP%"

:: Wait for PATH updates
timeout /t 10 >nul

:: Install Node.js LTS via NVM
echo Installing latest Node.js LTS...
nvm install lts
nvm use lts

:: Create shortcut to Node terminal
echo Creating Desktop Shortcut...
powershell -Command ^
  "$s = (New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); ^
   $s.TargetPath = '%ComSpec%'; ^
   $s.Arguments = '/k node -v && npm -v'; ^
   $s.IconLocation = '%SystemRoot%\System32\cmd.exe,0'; ^
   $s.Save()"

echo.
echo ✅ NVM installed, Node.js LTS active, and shortcut created!
pause
