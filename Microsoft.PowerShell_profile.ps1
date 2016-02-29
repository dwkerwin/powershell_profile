#
################################################################################
# Powershell Profile
#

# if a secrets file exists, run that first
# when setting variables in the secrets file, to overcome script scope,
# use $Global: syntax, # so to set $myvar = "", instead use $Global:myvar = ""
$secretsScript = Join-Path (Split-Path $PROFILE) "\secrets.ps1"
if (Test-Path $secretsScript ) {
    & $secretsScript
}

# auto load all powershell scripts in the autoload directory
$autoloadDir = Join-Path (Split-Path $PROFILE) "\autoload"
# run any script that doesn't start with _ (to temporarily stop a script from
# auto loading without moving it out of the directory, just add an _ to the
# beginning of the filename)
Get-ChildItem "${autoloadDir}\*.ps1" | % { if (!($_.Name.StartsWith("_"))) {.$_} }

# start off in the home directory
cd ~
