@echo off
setlocal EnableExtensions DisableDelayedExpansion
title GCC Installer

REM =========================
REM Config
REM =========================
set "APP=gcc"
set "LOG=%TEMP%\gcc-install-log.txt"

> "%LOG%" echo --- GCC Install Log started on %DATE% at %TIME% ---

REM =========================
REM Intro
REM =========================
cls
echo(
echo  GCC installer for Windows
echo  Uses Scoop (no admin)
echo(
echo  Log file:
echo  %LOG%
echo(

REM =========================
REM Admin check
REM =========================
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo(
    echo  Please do NOT run this as administrator.
    echo  Just double click it normally.
    echo(
    pause
    exit /b 1
)

REM =========================
REM PowerShell check
REM =========================
set "PSEXE="
where pwsh >nul 2>&1 && set "PSEXE=pwsh"
if not defined PSEXE where powershell >nul 2>&1 && set "PSEXE=powershell"

if not defined PSEXE (
    echo(
    echo  PowerShell not found.
    echo  It is required to install Scoop.
    echo(
    pause
    exit /b 1
)

REM =========================
REM Scoop detection
REM =========================
set "SCOOP_SHIMS="

if exist "%USERPROFILE%\scoop\shims\scoop.cmd" (
    set "SCOOP_SHIMS=%USERPROFILE%\scoop\shims"
    goto SCOOP_FOUND
)

for /f "delims=" %%S in ('where scoop 2^>nul') do (
    set "SCOOP_SHIMS=%%~dpS"
    goto SCOOP_FOUND
)

REM =========================
REM Install Scoop
REM =========================
echo  Scoop not found.
echo  Installing Scoop...
echo(

"%PSEXE%" -NoProfile -ExecutionPolicy Bypass -Command "try { [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-RestMethod 'https://get.scoop.sh' | Invoke-Expression } catch { exit 1 }" >> "%LOG%" 2>&1

if errorlevel 1 goto FAIL

set "SCOOP_SHIMS=%USERPROFILE%\scoop\shims"

REM =========================
:SCOOP_FOUND
echo  Checking environment settings...

set "PATH=%SCOOP_SHIMS%;%PATH%"

"%PSEXE%" -NoProfile -ExecutionPolicy Bypass -Command "$s='%SCOOP_SHIMS%'; $u=[Environment]::GetEnvironmentVariable('Path','User'); if ($u -notlike ('*'+$s+'*')) { [Environment]::SetEnvironmentVariable('Path',$u+';'+$s,'User') }" >> "%LOG%" 2>&1

REM =========================
REM Install GCC
REM =========================
echo  Installing gcc...

call "%SCOOP_SHIMS%\scoop.cmd" install %APP% >> "%LOG%" 2>&1

if exist "%SCOOP_SHIMS%\gcc.exe" goto SUCCESS
where gcc >nul 2>&1 && goto SUCCESS

goto FAIL

:SUCCESS
echo(
echo  Done. GCC installed.
echo(
echo  Next:
echo   - Close this window
echo   - Open a new terminal
echo   - Run: gcc --version
echo(
pause
exit /b 0

:FAIL
echo(
echo  Something went wrong.
echo(
echo  Check the log:
echo  %LOG%
echo(
echo  Common causes:
echo   - No internet
echo   - Antivirus blocking Scoop or PowerShell
echo(
pause
exit /b 1
