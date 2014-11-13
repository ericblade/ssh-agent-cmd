ssh-agent script for Windows CMD.exe

You hate entering your password over and over and over when you're using git in the Windows cmd.exe
Command Processor, right?

Me too.  So, here's a script that will launch ssh-agent, or connect to an existing one.
There's also a registry entry key that you can import, that will cause it to run the script automatically
in every command processor you open.

**** WARNING ****

YOU MUST EDIT THESE FILES AND PLACE THE CORRECT LOCATIONS TO YOUR FILES, OTHERWISE BAD THINGS MAY HAPPEN.

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

Sometimes while I was working on this, I saw a second ssh-agent pop up.  Not sure why.

Also, it looks like Windows keeps a lock on the socket after ssh-agent terminates, so if the process
gets killed somehow, you may need to edit the file and change the socket path, or reboot. It's really
weird.

**** License ****

This is free.  Plain-old free, public domain. As open as it gets.  Do whatever you want with it.
It'd be super nice, though, if you were to make any changes that someone else would find useful, if you
contributed those as a pull request.  Open source works best when everyone helps!

Please feel free to discuss this script at http://www.ericbla.de/phpBB3/viewtopic.php?f=6&t=27

And don't forget: Today, you should BE AWESOME.
