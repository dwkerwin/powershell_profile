#
################################################################################
# Powershell Customizations and Enhancements
# Auto-run at startup from profile
#

# configure the console UI
$Shell = $Host.UI.RawUI
$Shell.WindowSize.width = 160
$Shell.WindowSize.height = 50
$Shell.BufferSize.width = 160
$Shell.BufferSize.height = 5000
#$Shell.BackgroundColor = "DarkBlue"
#$Shell.ForegroundColor = "White"
#Clear-Host

# If an AWS profile is set, set the Posh and CLI creds for this session
# Expects the following fields to be set in the secrets.ps1 file
# $Global:aws_profile_name = "" # typically the IAM user name but doesn't have to be
# $Global:aws_key = ""
# $Global:aws_secret = ""
if ($aws_profile_name) {
	Write-Host "AWS Creds: $aws_profile_name"
	New-Item -Name "AWS_ACCESS_KEY_ID" -value "$aws_key" -ItemType Variable -Path "Env:" | Out-Null
	New-Item -Name "AWS_SECRET_ACCESS_KEY" -value "$aws_secret" -ItemType Variable -Path "Env:" | Out-Null
	Set-AWSCredentials -AccessKey $aws_key -SecretKey $aws_secret -StoreAs $aws_profile_name
}

$profileFolder = split-path $profile

# save last 100 history items on exit
$historyPath = Join-Path $profileFolder history.clixml

# hook powershell's exiting event & hide the registration with -supportevent.
Register-EngineEvent -SourceIdentifier powershell.exiting -SupportEvent -Action {
    Get-History -Count 100 | Export-Clixml (Join-Path (split-path $profile) history.clixml) }

# load previous history, if it exists
if ((Test-Path $historyPath)) {
    Import-Clixml $historyPath | ? {$count++;$true} | Add-History
    Write-Host "Loaded $count history item(s)."
}

# command aliases
set-alias s (Join-Path $Env:HomeDrive "\Program Files\Sublime Text 3\sublime_text.exe")
set-alias vscode (Join-Path $Env:HomeDrive "\Program Files (x86)\Microsoft VS Code\Code.exe")
# easier navigation
function  ..    {Set-Location ..}
function  ...   {Set-Location ..\..}
function  ....  {Set-Location ..\..\..}
function  ..... {Set-Location ..\..\..\..}
function google ($q) {start http://www.google.com/?#q=$q}
function so     ($q) {start http://stackoverflow.com/search?q=$q}
# notepad alias with args (another way to do it)
function Start-Notepad{
    notepad $args
}
set-alias n Start-Notepad

# find which version of the application you'll be calling, if any
function which($app)
{
    (Get-Command $app).Definition
}

# is the file anywhere in the path?
function Test-InPath($fileName){
    $found = $false
    Find-InPath $fileName | %{$found = $true}

    return $found
}

# find all versions of the file that might exist in the path
function Find-InPath($fileName){
    $env:PATH.Split(';') | ?{!([System.String]::IsNullOrEmpty($_))} | %{
        if(Test-Path $_){
            ls $_ | ?{ $_.Name -like $fileName }
        }
    }
}

# similar to linux's sudo
function Elevate-Process{
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi) >> $null
}
set-alias sudo Elevate-Process

# find the solution file and start Visual Studio
function Start-VisualStudio{
    param([string]$projFile = "")

    if($projFile -eq ""){
        ls *.sln | select -first 1 | %{
            $projFile = $_
        }
    }

    if(($projFile -eq "") -and (Test-Path src)){
        ls src\*.sln | select -first 1 | %{
            $projFile = $_
        }
    }

    if($projFile -eq ""){
        echo "No project file found"
        return
    }

    echo "Starting visual studio with $projFile"
    . $projFile
}
set-alias vs Start-VisualStudio

# shortcut to edit hosts file
function Set-Hosts{
    sudo notepad "$($env:SystemRoot)\system32\drivers\etc\hosts"
}
set-alias hosts Set-Hosts
