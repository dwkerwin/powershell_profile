# My Powershell Profile

When you start spending a lot of time in the command line, you'll want to customize your shell. And if you are in the shell a lot at work and after hours, it's convenient to have a framework for easily sharing helper functions.  This is my collection of powershell shortcuts and enhancements as well as a framework for auto loading scripts in such a way that I can sync this git repo at work and at home without worrying about sharing or overwriting data that is particular to each environment, like file paths and secrets.

### Autoloading

The main function of the base powershell profile is to process the autoloading.  It will automatically load any .ps1 script located in the `autoload-scripts` directory, unless the file begins with an _, which is just a handy way to temporarily disable autoloading of that script without moving the file from the directory.  Likewise, it will automatically import any modules found in the `autoload-modules` directory, unless they are prefixed with an _.

### Secrets

If you store any API keys or other sensitive informaiton in global powershell variables, you'll want to make sure this is never checked into Git.  The base powershell profile first includes the `secrets.ps1` file, if it exists.  When setting variables in secrets.ps1, to overcome script scope, use `$Global:` syntax, so to set `$myvar = ""`, instead use `$Global:myvar = ""`.  Secrets.ps1 is in the .gitignore so it will be excluded.  Naturally whatever is stored in this file is stored in cleartext and may be accessible to those with access to your machine, so this is intended for convenience only for low security secrets.

### Locals

Any custom settings that might be specific to work or home computers can be put in the `locals.ps1` scripts in the autoload-scripts directory so that it runs automatically like the profile itself, but aren't mixed in with the base profile, keeping it portable.  I like to set my paths in my powershell session rather than globally in Windows, so anything I need in the path I add to locals.ps1 like the following: 

```
$env:path += ';C:\Program Files\7-Zip\'
$env:path += ';C:\Program Files\Sublime Text 3\'
$env:path += ';C:\HashiCorp\Vagrant\bin\'
```

Naturally this will be custom to whatever applications you have installed, so locals.ps1 is in the .gitignore file.

### Helper Functions and Aliases

Most of the helpful enhancements and aliaases are in the poshenhance.ps1 file in the autoload-scripts directory.

### Powershell Version Compatibility

This has only been tested in Powershell 5.

### A quote for my friends who are still "pointing and clicking"

##### "The GUI isn't dead but it's dying on the server OS.  Don't be caught off guard when it's finally gone."
-Don Jones, Redmond Magazine, Jully 2011

***
