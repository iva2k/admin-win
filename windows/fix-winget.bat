:: When "WinGet COM Server" hogs 25% CPU, run this as an admin

@echo off
setlocal enableextensions enabledelayedexpansion
set me=%~n0
set parent=%~dp0
set parent=%parent:~0,-1%  && rem ## trim trailing slash

set interactive=0
echo %CMDCMDLINE% | findstr /L /I %COMSPEC% >NUL 2>&1
if %ERRORLEVEL% == 0 set interactive=1

call :ensure_admin
call :fix_winget
goto :eof

:fix_winget
  echo ==== WINGET SOURCE UPDATE
  winget source update
  echo.
  
  echo ==== SFC /SCANNOW
  sfc /scannow
  echo.
  
  echo ==== DISM /CHECKHEALTH
  dism /Online /Cleanup-Image /CheckHealth
  echo.
  
  echo ==== DISM /SCANHEALTH
  dism /Online /Cleanup-Image /ScanHealth
  echo.
  
  echo ==== DISM /RESTOREHEALTH
  dism /Online /Cleanup-Image /RestoreHealth
  echo.
  
  echo ==== DONE
  goto :eof

:ensure_admin
  net session >nul 2>&1
  if %errorlevel% == 0 (
    echo Running with administrator privileges.
  ) else (
    echo Please run this script with administrator privileges. Exiting.
    exit -1
  )
  goto :eof
