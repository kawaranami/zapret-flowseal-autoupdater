@echo off
setlocal ENABLEDELAYEDEXPANSION
cd /d "%~dp0"
set "ZAPRET_DIR=%cd%"
set "ZAPRET_REPO=https://github.com/Flowseal/zapret-discord-youtube"
set "ZAPRET_API=https://api.github.com/repos/Flowseal/zapret-discord-youtube"
set "TMP_ZIP=%TEMP%\zapret_update.zip"
set "TMP_DIR=%TEMP%\zapret_tmp"
set "LAST_UPDATE_FILE=%ZAPRET_DIR%\last_update.txt"

echo [zapret] Checking local installation...

if not exist "%ZAPRET_DIR%\install.bat" (
    echo [zapret] No installation found. Downloading latest release...
    if exist "%TMP_ZIP%" del /q "%TMP_ZIP%"
    if exist "%TMP_DIR%" rd /s /q "%TMP_DIR%"
    curl -L "%ZAPRET_REPO%/archive/refs/heads/main.zip" -o "%TMP_ZIP%" >nul 2>&1
    if not exist "%TMP_ZIP%" (
        echo [zapret] Download failed.
        pause
        exit /b
    )
    powershell -Command "Expand-Archive -Force '%TMP_ZIP%' '%TMP_DIR%'"
    xcopy "%TMP_DIR%\zapret-discord-youtube-main\*" "%ZAPRET_DIR%\" /E /Y >nul
    rd /s /q "%TMP_DIR%"
    del /q "%TMP_ZIP%"
    echo [zapret] Installation complete.
)

echo [zapret] Checking latest version on GitHub...
for /f "tokens=2 delims=:," %%a in ('curl -s %ZAPRET_API% ^| findstr "pushed_at"') do (
    set "REMOTE_DATE=%%~a"
)
if not defined REMOTE_DATE (
    echo [zapret] Failed to fetch remote info.
    pause
    exit /b
)
set "REMOTE_DATE=!REMOTE_DATE:~2,-2!"
if exist "%LAST_UPDATE_FILE%" (
    set /p LOCAL_DATE=<"%LAST_UPDATE_FILE%"
) else (
    set "LOCAL_DATE=none"
)
if "!REMOTE_DATE!"=="!LOCAL_DATE!" (
    echo [zapret] Already up to date.
    timeout /t 2 >nul
    goto runzapret
)
echo [zapret] New version detected, updating...
if exist "%TMP_ZIP%" del /q "%TMP_ZIP%"
if exist "%TMP_DIR%" rd /s /q "%TMP_DIR%"
curl -L "%ZAPRET_REPO%/archive/refs/heads/main.zip" -o "%TMP_ZIP%" >nul 2>&1
if not exist "%TMP_ZIP%" (
    echo [zapret] Download failed.
    pause
    exit /b
)
powershell -Command "Expand-Archive -Force '%TMP_ZIP%' '%TMP_DIR%'"
xcopy "%TMP_DIR%\zapret-discord-youtube-main\*" "%ZAPRET_DIR%\" /E /Y >nul
rd /s /q "%TMP_DIR%"
del /q "%TMP_ZIP%"
echo !REMOTE_DATE!>"%LAST_UPDATE_FILE%"
echo [zapret] Update complete.

:runzapret
if exist "%ZAPRET_DIR%\install.bat" (
    echo [zapret] Starting install.bat...
    cd /d "%ZAPRET_DIR%"
    call install.bat >nul 2>&1
)
if exist "%ZAPRET_DIR%\update.bat" (
    echo [zapret] Running update.bat...
    cd /d "%ZAPRET_DIR%"
    call update.bat >nul 2>&1
)
echo [zapret] Ready.
pause
exit /b
