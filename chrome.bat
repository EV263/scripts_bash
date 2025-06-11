@echo off
setlocal

echo ====================================
echo Downloading and Installing Chrome
echo ====================================

:: Set paths
set "INSTALLER_URL=https://dl.google.com/chrome/install/latest/chrome_installer.exe"
set "INSTALLER_PATH=%TEMP%\chrome_installer.exe"
set "SHORTCUT_NAME=Google Chrome.lnk"
set "TARGET_PATH=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
set "DESKTOP_PATH=%Public%\Desktop"

:: Download Chrome installer
echo Downloading Chrome installer...
powershell -Command "Invoke-WebRequest -Uri '%INSTALLER_URL%' -OutFile '%INSTALLER_PATH%'"

:: Install Chrome silently
echo Installing Chrome...
start /wait "" "%INSTALLER_PATH%" /silent /install

:: Wait a moment to ensure install finishes
timeout /t 10 >nul

:: Create desktop shortcut
echo Creating Desktop Shortcut...
powershell -Command ^
  "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); ^
   $s.TargetPath='%TARGET_PATH%'; 
   $s.IconLocation='%TARGET_PATH%,0';
   $s.Save()"

echo.
echo Chrome installed and shortcut created on Desktop!
pause
