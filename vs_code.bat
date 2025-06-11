@echo off
setlocal

echo ====================================
echo Downloading and Installing VS Code
echo ====================================

:: Set URLs and paths
set "VSCODE_URL=https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
set "INSTALLER_PATH=%TEMP%\VSCodeSetup.exe"
set "DESKTOP_PATH=%Public%\Desktop"
set "SHORTCUT_NAME=Visual Studio Code.lnk"
set "TARGET_PATH=%ProgramFiles%\Microsoft VS Code\Code.exe"

:: Download VS Code installer
echo Downloading VS Code installer...
powershell -Command "Invoke-WebRequest -Uri '%VSCODE_URL%' -OutFile '%INSTALLER_PATH%'"

:: Install VS Code silently
echo Installing VS Code...
start /wait "" "%INSTALLER_PATH%" /verysilent /mergetasks=!runcode

:: Wait a moment for installation
timeout /t 10 >nul

:: Create desktop shortcut
echo Creating Desktop Shortcut...
powershell -Command ^
  "$s=(New-Object -COM WScript.Shell).CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); 
   $s.TargetPath='%TARGET_PATH%'; 
   $s.IconLocation='%TARGET_PATH%,0';
   $s.Save()"

echo.
echo VS Code installed and shortcut created on Desktop!
pause
