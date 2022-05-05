@echo off

@REM This Batch file fixes all URL links (e.g. those created by Vivaldi) that pop up a confirmation dialog.

for %%a in (*.url) do call :fixit "%%a"
goto :eof

:fixit
set b="%~n1.bak"
copy %1 %b%
type %b% > %1
del /q %b% >NUL
goto :eof
