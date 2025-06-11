@echo off
setlocal

echo ==========================================
echo Downloading and Installing GitHub Desktop
echo ==========================================

:: Set download URL (always points to latest)
set "DOWNLOAD_URL=https://central.github.com/deployments/desktop/desktop/latest/win32"
set "INSTALLER_PATH=%TEMP%\GitHubDesktopSetup.exe"
set "SHORTCUT_NAME=GitHub Desktop.lnk"
set "DESKTOP_PATH=%Public%\Desktop"
set "INSTALL_PATH=%LocalAppData%\GitHubDesktop\GitHubDesktop.exe"

:: Step 1: Download GitHub Desktop
echo Downloading GitHub Desktop...
powershell -Command "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%INSTALLER_PATH%' -Headers @{ 'User-Agent'='Mozilla/5.0' }" || (
  echo ❌ Download failed.
  pause
  exit /b 1
)

:: Step 2: Install silently
echo Installing GitHub Desktop...
start /wait "" "%INSTALLER_PATH%" /silent || (
  echo ⚠️ Installer may require user interaction — continue if prompted.
)

:: Step 3: Wait and verify installation path
timeout /t 5 >nul

:: Step 4: Create desktop shortcut if app is installed
if exist "%INSTALL_PATH%" (
  echo Creating Desktop Shortcut...
  powershell -Command ^
    "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); ^
     $s.TargetPath='%INSTALL_PATH%'; ^
     $s.IconLocation='%INSTALL_PATH%,0'; ^
     $s.Save()" || echo ⚠️ Failed to create shortcut.
  echo ✅ GitHub Desktop installed and shortcut created.
) else (
  echo ⚠️ GitHub Desktop not found in expected location.
)

echo.
pause
