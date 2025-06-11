@echo off
setlocal

echo ===============================
echo Installing NVM and Node.js
echo ===============================

:: Set NVM for Windows installer version and URL
set NVM_VERSION=1.1.12
set NVM_URL=https://github.com/coreybutler/nvm-windows/releases/download/%NVM_VERSION%/nvm-setup.exe
set NVM_SETUP=nvm-setup.exe

:: Download NVM installer
echo Downloading NVM for Windows installer...
powershell -Command "Invoke-WebRequest -Uri '%NVM_URL%' -OutFile '%NVM_SETUP%'"

:: Run NVM installer (interactive setup)
echo Running NVM installer (follow setup wizard)...
start /wait %NVM_SETUP%

:: Remove installer
del %NVM_SETUP%

:: Ensure nvm is available in PATH
echo ===============================
echo Restarting shell for NVM...
echo ===============================
setx PATH "%PATH%;C:\Program Files\nvm" /M
setx PATH "%PATH%;C:\Program Files\nodejs" /M

:: Wait a bit to apply PATH
timeout /t 5 >nul

:: Use new environment (you may need to restart your terminal for full effect)
echo ===============================
echo Installing Node.js via NVM...
echo ===============================
call nvm install 20.12.2
call nvm use 20.12.2

:: Confirm installation
echo ===============================
echo Verifying installation...
echo ===============================
where nvm
where node
where npm

echo Node.js version:
node -v
echo npm version:
npm -v
echo NVM version:
nvm version

echo 🎉 All tools installed and globally accessible!

pause
endlocal
