@echo off
setlocal

echo =========================================
echo Downloading and Installing Node.js (LTS)
echo =========================================

:: Set correct official LTS download link
set "NODE_URL=https://nodejs.org/dist/v20.14.0/node-v20.14.0-x64.msi"
set "INSTALLER_PATH=%TEMP%\node-lts.msi"
set "SHORTCUT_NAME=Node.js Command Prompt.lnk"
set "DESKTOP_PATH=%Public%\Desktop"

:: Download Node.js LTS installer
echo Downloading Node.js installer...
powershell -Command "Invoke-WebRequest -Uri '%NODE_URL%' -OutFile '%INSTALLER_PATH%'"

:: Run Node.js installer with UI
echo Installing Node.js...
start /wait msiexec /i "%INSTALLER_PATH%"

:: Wait briefly
timeout /t 5 >nul

:: Create desktop shortcut to open command prompt with node and npm version check
echo Creating Desktop Shortcut...
powershell -Command ^
  "$s = (New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); ^
   $s.TargetPath = '%ComSpec%'; ^
   $s.Arguments = '/k node -v && npm -v'; ^
   $s.IconLocation = '%SystemRoot%\System32\cmd.exe,0'; ^
   $s.Save()"

echo.
echo ✅ Node.js LTS installed. Shortcut created on Desktop!
pause
