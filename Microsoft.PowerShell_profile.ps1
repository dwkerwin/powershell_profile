################################################################################
# Powershell Profile
#

# if a secrets file exists, include that first
$secretsScript = Join-Path (Split-Path $PROFILE) "\secrets.ps1"
if (Test-Path $secretsScript ) {
    . $secretsScript
}

# auto load all powershell modules and scripts in the autoload directory
$autoloadScriptsDir = Join-Path (Split-Path $PROFILE) "\autoload-scripts"
$autoloadModulesDir = Join-Path (Split-Path $PROFILE) "\autoload-modules"

# note that any module or script that starts with _ will be ignored
# (to temporarily stop a script from auto loading without moving it out of the directory,
# just add an _ to the beginning of the filename)
# auto load modules
Get-ChildItem -r "${autoloadModulesDir}\*.psm1" | % { if (!($_.Name.StartsWith("_"))) { Import-Module $_ } }
# auto load scripts
Get-ChildItem -r "${autoloadScriptsDir}\*.ps1" | % { if (!($_.Name.StartsWith("_"))) {. $_} }

# start off in the home directory
cd ~
