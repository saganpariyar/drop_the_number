@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   Drop The Number - Google Play Release Keystore Generator
echo ========================================================
echo.

set KEYSTORE_FILE=android\upload-keystore.jks
set PROP_FILE=android\key.properties

if exist "%KEYSTORE_FILE%" (
    echo [!] Release keystore already exists at %KEYSTORE_FILE%
    echo     Skipping keystore generation to prevent overwriting existing keys.
    goto create_prop
)

echo Generating a secure 2048-bit RSA upload keystore...
echo Please enter the password you want for your keystore (or press Enter to use default: dropnumber2026):
set /p USER_PASS=Keystore Password: 
if "%USER_PASS%"=="" set USER_PASS=dropnumber2026

echo.
echo Generating %KEYSTORE_FILE% ...
keytool -genkey -v -keystore "%KEYSTORE_FILE%" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass "%USER_PASS%" -keypass "%USER_PASS%" -dname "CN=Sobhait, OU=DropTheNumber, O=Sobhait, L=Bengaluru, ST=Karnataka, C=IN"

if %ERRORLEVEL% NEQ 0 (
    echo [X] Failed to create keystore! Make sure keytool is in your PATH.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [+] Keystore successfully created at %KEYSTORE_FILE%!

:create_prop
if exist "%PROP_FILE%" (
    echo [!] %PROP_FILE% already exists. Keeping current configuration.
) else (
    echo Creating %PROP_FILE% ...
    (
        echo storePassword=%USER_PASS%
        echo keyPassword=%USER_PASS%
        echo keyAlias=upload
        echo storeFile=upload-keystore.jks
    ) > "%PROP_FILE%"
    echo [+] Created %PROP_FILE% with signing credentials.
)

echo.
echo ========================================================
echo   Ready to build your signed production App Bundle (.aab)!
echo   Run: build_release_bundle.bat
echo ========================================================
pause

