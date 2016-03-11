# My Powershell Profile

When you start spending a lot of time in the command line, you'll want to customize your shell.  Here is my collection of powershell shortcuts and enhancements I've put together which I've found helpful.  Some are my own, and some are handy functions and modules I've come across (under the "vendor" directory).

### Autoloading

The main function of the base powershell profile is to process the autoloading.  It will automatically load any .ps1 script located in the `autoload-scripts` directory, unless the file begins with an _, which is just a handy way to temporarily disable autoloading of that script without moving the file from the directory.  Likewise, it will automatically import any modules found in the `autoload-modules` directory, unless they are prefixed with an _.

### Secrets

If you store any API keys or other sensitive informaiton in global powershell variables, you'll want to make sure this is never checked into Git.  The base powershell profile first includes the `secrets.ps1` file, if it exists.  When setting variables in secrets.ps1, to overcome script scope, use `$Global:` syntax, so to set `$myvar = ""`, instead use `$Global:myvar = ""`.  Secrets.ps1 is in the .gitignore so it will be excluded.

### Locals

Any custom settings that might be specific to work or home computers can be put in the `locals.ps1` scripts in the autoload-scripts directory so that it runs automatically like the profile itself, but aren't mixed in with the base profile, keeping it portable.  I like to set my paths in my powershell session rather than globally in Windows, so anything I need in the path I add to locals.ps1 like the following: 

```
$env:path += ';C:\Program Files\7-Zip\'
$env:path += ';C:\Program Files\Sublime Text 3\'
$env:path += ';C:\HashiCorp\Vagrant\bin\'
```

Naturally this will be custom to whatever applications you have installed, so locals.ps1 is in the .gitignore file.

### Helper Functions and Aliases

Most of the helpful enhancements and aliaases are in the poshenhance.ps1 file in the autoload-scripts directory.  There is also a small collection of AWS helper functions in `awshelpers.ps1`, which of course has the AWSPowerShell module as a dependency.

### Powershell Version Compatibility

This has only been tested in Powershell 5.

### A quote for my friends who are still "pointing and clicking"

##### "The GUI isn't dead but it's dying on the server OS.  Don't be caught off guard when it's finally gone."
-Don Jones, Redmond Magazine, Jully 2011

***
