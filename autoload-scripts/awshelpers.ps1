
<#
.SYNOPSIS
Initiates an RDP connection to an AWS EC2 instance given the instance name
.PARAMETER instanceId
The AWS name of the instance, e.g. 'i-ab123456'
.PARAMETER pw
Optional. This is a convenience only to place the PW on the clipboard for easy
pasting into the RDP window.  If omitted, will attempt to get the pw
from $Global:ec2pw, which you could set in the secrets.ps1 file.  This value can
also be set to "AUTO", in which case this will attempt to retrieve the AWS
automatically generated password from the EC2 API given the private key.
If using "AUTO", $Global:ec2pem needs to be set to contain the full file path to
the PEM file used to decrypt the password.
.EXAMPLE
rdpe i-ab123456
rdpe i-ab123456 -pw auto -pr
rdpe -instanceId i-ab123456 -pw auto -privateIp
#>
function RDP-EC2Instance($instanceId, $pw, [switch]$privateIp) {
    # Of course this has a dependency on the AWSPowerShell module
    if (!(Get-Module -Name "AWSPowerShell")) {
        echo "AWSPowerShell module not loaded!"
        return
    } else {
        if ($pw -eq $null) {
            # if no password parameter is sent, try tou se the Global
            if ($Global:ec2pw -eq $null) {
                echo "Note: Global:ec2pw not set. For pw assistance, set this or specify 'AUTO' for pw argument to retrieve the EC2 automatically generated password."
            } else {
                $pw = $Global:ec2pw    
            }
        } elseif ($pw.ToUpper() -eq "AUTO") {
            if ($Global:ec2pem -eq $null) {
                echo "No pem file location set (unable to decrypt password).  Set Global:ec2pem when using 'AUTO'"
                return
            } else {
                $pw = Get-EC2PasswordData -InstanceId $instanceId -PemFile $ec2pem
            }
        }
        if ($pw) {
            # copy the password to the clipboard so it can be easily pasted into the RDP window
            $pw | clip
        }

        if ($privateIp.IsPresent) {
            $ipaddr = (aws ec2 describe-instances --instance-ids $instanceId | ConvertFrom-Json).Reservations[0].Instances[0].PrivateIpAddress
        } else {
            $ipaddr = (aws ec2 describe-instances --instance-ids $instanceId | ConvertFrom-Json).Reservations[0].Instances[0].PublicIpAddress
        }

        # wait until we can connect (if the instance was just started it may not be ready yet)
        do {
            $conTest = Test-NetConnection -ComputerName $ipaddr -CommonTCPPort RDP
        } until ($conTest.TcpTestSucceeded -eq $true)

        # initiate the RDP connection
        # handy tip - use the down arrow key to enter a new username such as Administrator
        mstsc /v:$ipaddr
    }
}
set-alias rdpe RDP-EC2Instance

# returns instances only for any matching the name (case sensitive)
function List-EC2InstancesByName ($name)
{
    $instanceList = aws ec2 describe-instances --filters "Name=tag:Name,Values=*$name*" | ConvertFrom-Json

    $runningInstances = $instanceList.Reservations.Instances | `
        # where { $_.State.Name -eq "running" } | `
        select InstanceId, InstanceType, VpcId, State, LaunchTime, Tags | `
        sort VpcId, LaunchTime -desc

    if ($runningInstances.Count -eq 0) {
        echo "No matching instances.  Remember tag name compare is case sensitive :("
    } else {
        $runningInstances | ft -auto
    }
}
set-alias liste List-EC2InstancesByName
