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

# auto load all powershell modules and scripts in the autoload directory
$autoloadDir = Join-Path (Split-Path $PROFILE) "\autoload"

# note that any module or script that starts with _ will be ignored
# (to temporarily stop a script from auto loading without moving it out of the directory,
# just add an _ to the beginning of the filename)

# auto load modules
Get-ChildItem -r "${autoloadDir}\*.psm1" | % { if (!($_.Name.StartsWith("_"))) { Import-Module $_ } }

# auto load scripts
Get-ChildItem -r "${autoloadDir}\*.ps1" | % { if (!($_.Name.StartsWith("_"))) {.$_} }

# give a fancy greeting
if (Get-Module -Name "Write-Ascii") {
    Write-Ascii "powershell"
}
    
# start off in the home directory
cd ~
