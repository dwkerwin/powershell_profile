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
Get-ChildItem -r "${autoloadDir}\*.psm1" | % { Import-Module $_ }
Get-ChildItem -r "${autoloadDir}\*.ps1" | % { .$_ }

# start off in the home directory
cd ~
