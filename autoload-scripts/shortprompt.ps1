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
   $clocStack = [ConsoleColor]::Yellow
   $hostName = [net.dns]::GetHostName()
   $machineName = $hostName
   write-host "PS " -n
   write-host ($machineName) -n -f $chost 
   write-host ' ' -n -f $cdelim 

   # if there are directories on the stack (pushd/popd), show the stack count
   $locationStackSize = (pwd -stack).Count
   if ($locationStackSize) {
      write-host "+$locationStackSize" -n -f $clocStack
      write-host ' ' -n -f $cdelim
   }

   write-host (shorten-path (pwd).Path) -n -f $cloc
   # if posh-git is installed, incorporate git status into the prompt 
   if (Get-Module -Name "posh-git") {
      $global:GitStatus = Get-GitStatus
      if ($GitStatus.Branch -ne "(unknown)") {
         Write-GitStatus $GitStatus
      }
   }
   write-host " " -n
   return "> "
}
