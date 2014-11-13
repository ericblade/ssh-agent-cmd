@echo off
rem -- This prevents us from infinite looping at startup.
rem -- Surprise! "FOR" runs a new command processor for every loop! Wow!
IF DEFINED SSH_AGENT_SEARCHING (GOTO :eof)
set SSH_AGENT_SEARCHING=1

rem -- *** SET THIS PATH TO THE LOCATION WHERE YOUR SSH BINARIES ARE
set SSH_BIN_PATH="c:\program files (x86)\git\bin\"
rem -- NOTE: If you kill an agent, the socket file remains locked by Windows! Bad!
rem -- This means you'll need to change the below filename if you want to run the
rem -- script again without rebooting.
set SSH_AUTH_SOCK=%TEMP%\ssh-agent-socket.temp

:checkAgent
echo Looking for existing ssh-agent...
FOR /F "tokens=1-2" %%A IN ('tasklist^|find /i "ssh-agent.exe"') DO @(IF %%A==ssh-agent.exe (call :agentexists %%B))
echo Finished looking...
IF NOT DEFINED SSH_AGENT_PID (call :startagent)
GOTO :eof

:doAdds
 FOR /R %USERPROFILE%\.ssh\ %%A in (*_rsa.) DO %SSH_BIN_PATH%\ssh-add %%A
 GOTO :eof

:wtf
 @echo "WTF"
 GOTO :eof

:agentexists
 ECHO Agent exists as process %1
 SET SSH_AGENT_PID=%1
 GOTO :eof

:startagent
 ECHO Starting agent
 %SSH_BIN_PATH%\ssh-agent -a %SSH_AUTH_SOCK%
 rem -- Yes, I know this could cause an infinite loop if it can't find one and can't start one.
 rem -- I can't seem to figure out how to prevent that.  
 GOTO :checkAgent

:eof
