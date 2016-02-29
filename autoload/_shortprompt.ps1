function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths sing with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

# alternate shorter prompt, uses shorten-path function
function prompt { 
   $cdelim = [ConsoleColor]::DarkCyan 
   $chost = [ConsoleColor]::Green 
   $cloc = [ConsoleColor]::Cyan    
   $hostName = [net.dns]::GetHostName()
   $machineName = $hostName
   write-host ($machineName) -n -f $chost 
   write-host ' ' -n -f $cdelim 
   write-host (shorten-path (pwd).Path) -n -f $cloc 
   $global:GitStatus = Get-GitStatus
   Write-GitStatus $GitStatus
   write-host "`r`n$" -n -f $cdelim 
   return ' ' 
}
