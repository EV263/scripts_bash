@echo off
setlocal

echo =======================================
echo Downloading and Installing Python 3.x.x
echo =======================================

:: Set download URL for the latest Python 3.x (64-bit)
set "PYTHON_URL=https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"
set "INSTALLER=%TEMP%\python-installer.exe"

:: Download installer
echo Downloading Python installer...
powershell -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%INSTALLER%'"

:: Install Python silently for all users with pip and PATH enabled
echo Installing Python silently...
start /wait "" "%INSTALLER%" ^
    /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_doc=0 Include_pip=1

:: Confirm installation
echo =======================================
echo Python version:
python --version

echo Pip version:
pip --version
echo =======================================

echo ✅ Python installed and available globally.
pause
