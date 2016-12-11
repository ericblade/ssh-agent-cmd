@echo off
rem -- *** from http://github.com/ericblade/ssh-agent-cmd - free for all use.

rem -- This prevents us from infinite looping at startup.
rem -- Surprise! "FOR" runs a new command processor for every loop! Wow!
rem -- So, this is put at the top to short circuit any additional executions that might happen
rem -- as a side effect of other commands inside.
IF DEFINED SSH_AGENT_SEARCHING (GOTO :eof)
set SSH_AGENT_SEARCHING=1

rem -- *** SET SSH_BIN_PATH TO THE LOCATION WHERE YOUR SSH BINARIES ARE IF NOT INSTALLED WITH GIT IN
rem -- *** THE NORMAL PLACE (\program files\ or \program files (x86)\)
if not defined SSH_BIN_PATH (
    echo Searching for SSH bin path... Define SSH_BIN_PATH to override.

    if exist "%ProgramFiles%\git\usr\bin\ssh-agent.exe" (
        set SSH_BIN_PATH="%ProgramFiles%\git\usr\bin\"
    ) else if exist "%ProgramFiles(x86)%\git\usr\bin\ssh-agent.exe" (
        set SSH_BIN_PATH="%ProgramFiles(x86)%\git\usr\bin\"
    )

    if defined SSH_BIN_PATH (
        setlocal enabledelayedexpansion
        echo Found !SSH_BIN_PATH!...
        endlocal
    )
)

IF NOT EXIST %SSH_BIN_PATH%\ssh-agent.exe (
    echo "*** Unable to find ssh-agent.exe in %ProgramFiles%\git\usr\bin or %ProgramFiles(x86)%\git\usr\bin or %SSH_BIN_PATH%\. Check SSH_BIN_PATH."
    exit /b
)

rem -- NOTE: If you kill an agent, the socket file remains locked by Windows! Bad!
rem -- This means you'll need to change the below filename if you want to run the
rem -- script again without rebooting.
rem -- ** NEW NOTE: This no longer seems to be the case in Windows 10 AU. Not sure when
rem -- exactly that changed between 8.0 and 10AU, but it's a welcome fix!

set SSH_AUTH_SOCK=%TEMP%\ssh-agent-socket.tmp

:checkAgent
SET "SSH_AGENT_PID="
rem -- Get a list of all running tasks, and search it for ssh-agent.exe, record that process id in
rem -- SSH_AGENT_PID.
rem -- Call cmd /c to get a known working tasklist command, because Take Command's "tasklist" is NOT format compatible with CMD.exe!!
FOR /F "tokens=1-2" %%A IN ('cmd /c tasklist^|find /i "ssh-agent.exe"') DO @(IF %%A==ssh-agent.exe (call :agentexists %%B))
rem -- If no SSH_AGENT_PID found, then start a new instance of ssh-agent.exe
IF NOT DEFINED SSH_AGENT_PID (GOTO :startagent)
CALL :setregistry
GOTO :eof

:doAdds
 rem -- Grab all the *_rsa.* files in %USERPROFILE% and add them to the agent, this will probably
 rem -- prompt you for passwords to those keys.
 FOR /R %USERPROFILE%\.ssh\ %%A in (*_rsa.) DO %SSH_BIN_PATH%\ssh-add %%A >nul 2>&1
 EXIT /b

:agentexists
 SET SSH_AGENT_PID=%1
 GOTO :setregistry

:startagent
 rem -- win 8.1 at least has these set as system, so you can't delete them
 attrib -s %SSH_AUTH_SOCK% >nul 2>&1
 del /f /q %SSH_AUTH_SOCK% >nul 2>&1
 %SSH_BIN_PATH%\ssh-agent -a %SSH_AUTH_SOCK% >nul 2>&1
 CALL :doAdds
 rem -- recheck the agent to make sure that it launched properly.
 rem -- Yes, I know this could cause an infinite loop if it can't find one and can't start one.
 rem -- If you find a common cause for this to be a problem, file a bug, or submit a pull
 rem -- request to fix it :-)
 GOTO :checkAgent

:setregistry
 rem -- store these variables to the global environment -- note that this can and will NOT affect
 rem -- any open shells or other running programs.  This also includes affecting new shells opened
 rem -- by already running programs, such as using the "New Tab" button in ConsoleZ.  This will
 rem -- only take affect automatically in completely new processes.
 SetX SSH_AUTH_SOCK %SSH_AUTH_SOCK% >nul 2>&1
 SetX SSH_AGENT_PID %SSH_AGENT_PID% >nul 2>&1
 set SSH_AGENT_SEARCHING=
 EXIT /b

:eof
