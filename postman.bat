@echo off
setlocal

echo ====================================
echo Downloading and Installing Postman
echo ====================================

:: Set URLs and paths
set "POSTMAN_URL=https://dl.pstmn.io/download/latest/win64"
set "INSTALLER_PATH=%TEMP%\Postman-win64-setup.exe"
set "DESKTOP_PATH=%Public%\Desktop"
set "SHORTCUT_NAME=Postman.lnk"
set "TARGET_PATH=%ProgramFiles%\Postman\Postman.exe"

:: Download Postman installer
echo Downloading Postman installer...
powershell -Command "Invoke-WebRequest -Uri '%POSTMAN_URL%' -OutFile '%INSTALLER_PATH%'"

:: Install Postman silently
echo Installing Postman...
start /wait "" "%INSTALLER_PATH%" /silent

:: Wait for install to finish
timeout /t 10 >nul

:: Create desktop shortcut
echo Creating Desktop Shortcut...
powershell -Command ^
  "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); ^
   $s.TargetPath='%TARGET_PATH%'; ^
   $s.IconLocation='%TARGET_PATH%,0';
   $s.Save()"

echo.
echo Postman installed and shortcut created on Desktop!
pause
