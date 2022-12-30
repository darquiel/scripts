#New-Item -Path alias:VSCode -value 'open -a "Visual Studio Code"'
Set-Alias -name vscode -value start-visualstudiocode -option AllScope -Force
Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(/usr/local/bin/brew shellenv) | Invoke-Expression'

function start-visualstudiocode {
<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  Basic script to open VSCode with a particular file - to the GUI...
.NOTES
  Version:        1.0
  Author:         Mark Andrews
  Creation Date:  2/28/2017
  Purpose/Change: Initial script development 
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

  Param(
    [string]$file2Edit = $PROFILE
  )

  # #New-Item -Path alias:VSCode -value 'open -a "Visual Studio Code"'
  $command = 'open -a "Visual Studio Code"' + " " + $file2Edit
  Invoke-Expression $command
  # end
}

set-location "~/scripts/PS1"
clear