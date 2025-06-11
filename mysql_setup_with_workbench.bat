@echo off
setlocal enabledelayedexpansion

:: --- Configuration ---
set MYSQL_VERSION=8.0.42
set MYSQL_SERVER_ZIP_URL=https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-%MYSQL_VERSION%-winx64.zip
set MYSQL_WORKBENCH_URL=https://dev.mysql.com/get/Downloads/MySQLWorkbench/mysql-workbench-community-8.0.42-winx64.msi

set INSTALL_DIR=C:\MySQL
set MYSQL_ZIP=mysql.zip
set EXTRACT_DIR=%INSTALL_DIR%\mysql-%MYSQL_VERSION%-winx64
set BIN_DIR=%EXTRACT_DIR%\bin

set WORKBENCH_INSTALLER=mysql-workbench.msi

:: --- Download MySQL Server ZIP ---
echo.
echo ================================
echo Downloading MySQL Server %MYSQL_VERSION%
echo ================================
if exist %MYSQL_ZIP% del /f /q %MYSQL_ZIP%
curl -L -o %MYSQL_ZIP% %MYSQL_SERVER_ZIP_URL%
if errorlevel 1 (
    echo ERROR: MySQL Server download failed!
    pause
    exit /b 1
)

:: --- Extract MySQL Server ---
echo.
echo ================================
echo Extracting MySQL Server to %INSTALL_DIR%
echo ================================
if exist "%EXTRACT_DIR%" (
    echo Removing existing directory "%EXTRACT_DIR%"
    rmdir /s /q "%EXTRACT_DIR%"
)
powershell -Command "Expand-Archive -Force '%MYSQL_ZIP%' '%INSTALL_DIR%'"
if errorlevel 1 (
    echo ERROR: Extraction failed!
    pause
    exit /b 1
)

:: --- Add MySQL bin to system PATH ---
echo.
echo ================================
echo Adding MySQL bin to system PATH
echo ================================
setlocal enabledelayedexpansion
set "CURRENT_PATH="
for /f "usebackq tokens=*" %%a in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul`) do (
    set "line=%%a"
    if "!line:~0,4!"=="Path " (
        for /f "tokens=2,*" %%i in ("!line!") do set "CURRENT_PATH=%%j"
    )
)
endlocal & set "CURRENT_PATH=%CURRENT_PATH%"

echo Checking if "%BIN_DIR%" is already in PATH...
echo %CURRENT_PATH% | find /i "%BIN_DIR%" >nul
if errorlevel 1 (
    echo Not found in PATH, adding...
    setx /M PATH "%CURRENT_PATH%;%BIN_DIR%"
    echo Added MySQL bin to system PATH.
) else (
    echo MySQL bin folder already in system PATH.
)

:: --- Initialize MySQL data directory ---
echo.
echo ================================
echo Initializing MySQL data directory
echo ================================
cd /d "%BIN_DIR%"
mysqld --initialize --console
if errorlevel 1 (
    echo WARNING: Data directory initialization may have failed or was already done.
)

:: --- Install MySQL service ---
echo.
echo ================================
echo Installing MySQL service
echo ================================
mysqld --install MySQL
if errorlevel 1 (
    echo WARNING: Service may already be installed.
)

:: --- Start MySQL service ---
echo.
echo ================================
echo Starting MySQL service
echo ================================
net start MySQL

:: --- Download MySQL Workbench installer ---
echo.
echo ================================
echo Downloading MySQL Workbench
echo ================================
if exist %WORKBENCH_INSTALLER% del /f /q %WORKBENCH_INSTALLER%
curl -L -o %WORKBENCH_INSTALLER% %MYSQL_WORKBENCH_URL%
if errorlevel 1 (
    echo ERROR: MySQL Workbench download failed!
    pause
    exit /b 1
)

:: --- Install MySQL Workbench silently ---
echo.
echo ================================
echo Installing MySQL Workbench silently
echo ================================
msiexec /i %WORKBENCH_INSTALLER% /quiet /norestart
if errorlevel 1 (
    echo ERROR: MySQL Workbench installation failed!
    pause
    exit /b 1
)

:: --- Create MySQL Workbench connection file ---
echo.
echo ================================
echo Creating MySQL Workbench connection file
echo ================================
set WB_CONN_DIR=%APPDATA%\MySQL\Workbench

if not exist "%WB_CONN_DIR%" (
    mkdir "%WB_CONN_DIR%"
)

set CONN_FILE=%WB_CONN_DIR%\connections.xml

(
echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes" ?^>
echo ^<connections^>
echo     ^<connection name="Local MySQL Server" host="127.0.0.1" port="3306" user="root" /^>
echo ^</connections^>
) > "%CONN_FILE%"

echo MySQL Workbench connection "Local MySQL Server" created.

echo.
echo ================================================
echo Installation complete!
echo - Close this window.
echo - Open a NEW Command Prompt window.
echo - Run 'mysql --version' to check CLI access.
echo - Run MySQL Workbench from Start Menu to use GUI.
echo - You will see "Local MySQL Server" connection preset in Workbench.
echo ================================================

pause
