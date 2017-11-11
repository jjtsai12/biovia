@echo off
echo I am %COMPUTERNAME%

:checkPermission
net session >nul 2>&1
if %errorLevel% == 0 (
	REM echo Success: Administrative permissions confirmed.
) else (
	echo Failure: Requires Administrative permissions.
	GOTO ERROR_HANDLER
)

REM if didn't specify arguments, just run the ConfigureRemotingForAnsible, don't add local user
IF %1.==. GOTO ANSIBLESETUP
IF %2.==. GOTO ANSIBLESETUP

:ADDUSER
echo Adding user %1
net user /add %1 %2
ECHO DEBUG: %~n0: expecting errorlevel 0, got error level: %ERRORLEVEL%
IF %ERRORLEVEL% EQU 2 GOTO ADMINISTRATOR
IF %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER

:ADMINISTRATOR
echo Adding user to Administrators...
net localgroup Administrators /add %1
ECHO DEBUG: %~n0: expecting errorlevel 0, got error level: %ERRORLEVEL%
IF %ERRORLEVEL% EQU 2 GOTO END
IF %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER

:ANSIBLESETUP
echo Enabling PowerShell Remoting for Ansible...
REM @powershell -NoProfile -ExecutionPolicy bypass -command "Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))"
@powershell -NoProfile -ExecutionPolicy bypass -command "$script=((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1')); Invoke-Command -ScriptBlock ([scriptblock]::Create($script)) -ArgumentList -EnableCredSSP"
ECHO DEBUG: %~n0: expecting errorlevel 0, got error level: %ERRORLEVEL%

:END
echo.
echo Successfully ran %~n0 !!!
GOTO QUIT

:ERROR_HANDLER
echo.
echo Error occurred!!!
exit /b 1

:QUIT
echo.