<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  helper script to configure FreeRadius remotely
.INPUTS
  
.OUTPUTS
  Script applies updates to the FreeRadius configuration for accounts and ipaddress range.
.NOTES
  Version:        -- see the GIT repos for version history
  Repos:          https://azriel.visualstudio.com/_git/scripts
  Author:         MjA
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

Param(
  [string]$trgtHost = "bjorn",
  [string]$trgtAccount = "mja",
  [string]$cyRadAccount = "Home",
  [string]$cyRadPasswd = "Cylntm-auth"
)

Clear-Host
$sshConnection = $trgtAccount + '@' + $trgtHost

function StageAutorizeCnfg {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageAutorizeCnfg :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  
  # check for exisitng file and remove it / then unzip the file
  ssh $sshConnection "if [ -f stageauthorize ]; then rm stageauthorize; fi"
    
  if (Test-Path -Path stage.txt -PathType Leaf) {
    rm stage.txt
  }
  
  $testString = $cyRadAccount + "`tCleartext-Password := `"" + $cyRadPasswd + "`"" + "`n`tReply-Message := `"Authorized, %{User-Name}`""
  Write-Host $testString
  Add-Content -Path stage.txt -Value $testString
  
  cat stage.txt | ssh $sshConnection 'cat - > stageauthorize'
  ssh $sshConnection 'cat stageauthorize >> /etc/freeradius/3.0/mods-config/files/authorize'

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageAutorizeCnfg :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function RestartFRD {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " RestartFRD :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"

  ssh $sshConnection 'sudo killall freeradius'
  ssh $sshConnection 'sudo freeradius'

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host "  RestartFRD :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

#StageAutorizeCnfg
RestartFRD

# end