ssh-agent script for Windows CMD.exe

You hate entering your password over and over and over when you're using git in the Windows cmd.exe
Command Processor, right?

Me too.  So, here's a script that will launch ssh-agent, or connect to an existing one.

There's also a registry entry key that you can import, that will cause it to run the script automatically
in every command processor you open.

You probably DO NOT need to use the auto-start registry hack.  If you place
this script in your startup folder, it should successfully write the variables
to your global registry, therefore allowing any further command shells
that are spawned to know how to use the ssh-agent.

**** WARNINGS ****

IF YOU USE THE REGISTRY HACK TO AUTO-START THIS SCRIPT, YOU MUST EDIT THESE FILES AND PLACE THE CORRECT LOCATIONS TO YOUR FILES, OTHERWISE BAD THINGS MAY HAPPEN.

**** Installation ****

Place sshagent.cmd somewhere within your system.  Edit it to change the SSH_BIN_PATH variable.

If you want to use the registry entry, edit the autorun.reg file, and change the path listed in
"AutoRun"="d:\\\\sshagent.cmd" to point to the location where your sshagent.cmd you will be using is.
Then double-click the autorun.reg file. (Make sure you use double slashes in this file!
If you screw up this file, I don't know what will happen. Maybe nothing, maybe you won't be able to
start a command window again without undoing it)

If you have git 1.7.0 for windows or better, and you are constantly nagged by github to enter
credentials for https accesses, you might try:

git config --global credential.helper wincred

**** Caveats ****

This will add the following environment variables to your global registry:
SSH_AGENT_PID (contianing the process id of the ssh-agent.exe instance)
SSH_AUTH_SOCK (containing the path to the socket file used by ssh-agent)

If you do not already have an environment variable called SSH_BIN_PATH, then that will be added
for the specific shell that runs this script.

If you use a multi-shell app such as ConsoleZ or Console2 or some such, and you run this script initially
inside a shell started from that app, then use the "New Tab", the new tab will inherit the old environment,
as it is actually launched by the app, which still has the old environment.  Open a new window.

**** License ****

This is free.  Plain-old free, public domain. As open as it gets.  Do whatever you want with it.
It'd be super nice, though, if you were to make any changes that someone else would find useful, if you
contributed those as a pull request.  Open source works best when everyone helps!

Please feel free to discuss this script at http://www.ericblade.us/phpBB3/viewtopic.php?f=6&t=27

Report problems and send pull requests at http://github.com/ericblade/ssh-agent-cmd

And don't forget: Today, you should BE AWESOME.
