@echo off

:: Created by: Ionut (Mike) Dutan
:: Created on: February 20, 2026
:: Version: Revision 1

:: Opening CMD maximized
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b\

echo ************************ Microsoft 365 Apps Update to Semi-Annual Channel process ************************

:: Prompt to Run as administrator
Set "Variable=0" & if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
fsutil dirty query %systemdrive%  >nul 2>&1 && goto :start
If "%1"=="%Variable%" (echo. &echo. Please right-click on the file and select &echo. "Run as administrator". &echo. Press any key to exit. &pause>nul 2>&1& exit)
cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~0", "%Variable%", "", "runas", 1 > "%temp%\getadmin.vbs"&cscript //nologo "%temp%\getadmin.vbs" & exit

:start
setlocal EnableExtensions

:: Set console color light green
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

echo %ESC%[32m1. Setting Microsoft 365 Apps update Semi-Annual Channel ...%ESC%[0m
:: Registry path and Semi-Annual Update Channel CDN URL
set "REGPATH=HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
set "CURRENTCHANNEL=http://officecdn.microsoft.com/pr/7ffbc6bf-bc32-4f92-8982-f9dd17fd3114"
:: Set CDNBaseUrl, UpdateChannel, UpdateUrl and UnmanagedUpdateUrl
reg add "%REGPATH%" /v UpdateChannel /t REG_SZ /d "%CURRENTCHANNEL%" /f >nul
reg add "%REGPATH%" /v CDNBaseUrl /t REG_SZ /d "%CURRENTCHANNEL%" /f >nul
reg add "%REGPATH%" /v UpdateUrl /t REG_SZ /d "%CURRENTCHANNEL%" /f >nul
reg add "%REGPATH%" /v UnmanagedUpdateUrl /t REG_SZ /d "%CURRENTCHANNEL%" /f >nul
echo %ESC%[32m2. Registry updated successfully.%ESC%[0m

:: Locate OfficeC2RClient.exe and trigger update
set "C2R=%ProgramFiles%\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
if not exist "%C2R%" set "C2R=%ProgramFiles(x86)%\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"

if not exist "%C2R%" (
echo %ESC%[32mWARNING^: OfficeC2RClient.exe not found.%ESC%[0m
echo %ESC%[32mChannel was set^, but the update trigger could not be started.%ESC%[0m
echo Open Control Panel ^> Uninstall Apps ^> Select Microsoft 365 ^> Click Change ^> Select Quick Repair
echo Afterwards Update Office^: Open Outlook ^> Click File ^> Office Account ^> Select Update.%ESC%[0m 
echo.
echo Press any key to close.
endlocal
pause
)
echo %ESC%[32m3. Triggering Office update...%ESC%[0m
start "" /wait "%C2R%" /update user
echo %ESC%[32mDone.%ESC%[0m
echo ************************
echo %ESC%[32mThe Microsoft 365 Apps update Semi-Annual Channel from OBIFTP process is now complete.%ESC%[0m
echo ************************
echo %ESC%[32m4. Next steps: Wait for Microsoft Update prompt to finish downloading and applying the updates.%ESC%[0m 
echo %ESC%[32m5. Then: Close the prompt and verify in an Office app (Example: Outlook): File ^> Office Account ^> About (should show Semi-Annual Channel Build 2508).%ESC%[0m 
echo.
endlocal
pause