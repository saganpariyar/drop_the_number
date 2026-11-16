@echo off
setlocal

echo ========================================================
echo   Drop The Number - Building Production App Bundle (.aab)
echo ========================================================
echo.

cd /d "%~dp0"

echo Running Flutter clean build...
call C:\Projects\flutter\bin\flutter.bat build appbundle --release --android-skip-build-dependency-validation

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo [+] Production App Bundle (.aab) successfully built!
    echo.
    echo Upload File Location:
    echo %~dp0build\app\outputs\bundle\release\app-release.aab
    echo ========================================================
    explorer.exe /select,"%~dp0build\app\outputs\bundle\release\app-release.aab"
) else (
    echo.
    echo [X] Build failed! Check the error output above.
)

pause

