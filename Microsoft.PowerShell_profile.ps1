#
####################################################################################
# Powershell Profile
#

# if a secrets file exists, run that first
$secretsScript = Join-Path (Split-Path $PROFILE) "\secrets.ps1"
if (Test-Path $secretsScript ) {
    & $secretsScript
}

# auto load all powershell scripts in the autoload directory
$autoloadDir = Join-Path (Split-Path $PROFILE) "\autoload"
Get-ChildItem "${autoloadDir}\*.ps1" | %{.$_} 

# start off in the home directory
cd ~
