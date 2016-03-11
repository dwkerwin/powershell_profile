# My Powershell Profile

##### "The GUI isn't dead but it's dying on the server OS.  Don't be caught off guard when it's finally gone."
-Don Jones, Redmond Magazine, Jully 2011

***
When you start spending a lot of time in the command line, which you will do when working with AWS, dynamic configuration of ephemeral resources, or just about any modern software development, you'll want to customize your shell.  Here is my collection of powershell shortcuts and enhancements I've picked up along the way.  Some are my own, and some are handy functions and modules I've come across (under the vendor directory).

The structure is in a reusable format so that it could be portable between work and home computers, etc.  So any passwords, AWS creds, etc. are kept in a secrets.ps1 file which is not checked in.  When setting variables in secrets.ps1, to overcome script scope, use `$Global:` syntax, so to set `$myvar = ""`, instead use `$Global:myvar = ""`

Most of the enhancements are in the poshenhance.ps1 file in the autoload directory.  The base powershell profile will run all the scripts in the autoload directory which do not start with an underscore.  Therefore poshenhance.ps1 will get run automatically.  Also, any custom settings that might be specific to work or home computers can be put in separate scripts in the autoload directory so that they run automatically like the profile itself, but aren't mixed in with the actual profile, keeping it portable.

# Powershell Version Compatibility

This has only been tested in Powershell 5.
