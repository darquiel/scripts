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
  [string]$cyRadPasswd = "Cylntm-auth",
  [string]$cyRadClientName = "private-network-cylntm",
  [string]$cyRadClientSecret = "cylntm-123",
  [string]$cyRadClientIPAddr = "172.16.52.0/24"
)

Clear-Host
$sshConnection = $trgtAccount + '@' + $trgtHost

function StageAuthorizeCnfg {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageAuthorizeCnfg :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  
   
  if (Test-Path -Path stage.txt -PathType Leaf) {
    rm stage.txt
  }
  
  $testString = $cyRadAccount + "`tCleartext-Password := `"" + $cyRadPasswd + "`"" + "`n`tReply-Message := `"Authorized, %{User-Name}`""
  Write-Host $testString
  Add-Content -Path stage.txt -Value $testString
  
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageAuthorizeCnfg :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

# Stage NetworkSettings (Client)
#Client private-network-1 {
#  Ipaddr    = 172.16.52.0/24
#  secret    = cylntm-123
#}

function StageClientCnfg {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageClientCnfg :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  
   
  if (Test-Path -Path stage2.txt -PathType Leaf) {
    rm stage2.txt
  }
  
  $test2String = "client " + $cyRadClientName + " {`n`tIpaddr`t= " + $cyRadClientIPAddr + "`n`tsecret`t= " + $cyRadClientSecret + "`n}"
  Write-Host $test2String
  Add-Content -Path stage2.txt -Value $test2String
  
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageClientCnfg :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function TrnsfrStageCnfg {

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " TrnsfrStageCnfg :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

  # check for exisitng file and remove it / then unzip the file
  ssh $sshConnection "if [ -f stageauthorize ]; then rm stageauthorize; fi"
  ssh $sshConnection "if [ -f stageclient ]; then rm stageclient; fi"

  cat stage.txt | ssh $sshConnection 'cat - > stageauthorize'
  cat stage2.txt | ssh $sshConnection 'cat - > stageclient'

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " TrnsfrStageCnfg :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

}

function RestartFRD {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " RestartFRD :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"

  #apply configuration
  ssh $sshConnection 'cat stageauthorize >> /etc/freeradius/3.0/mods-config/files/authorize'

  ssh $sshConnection 'sudo killall freeradius'
  ssh $sshConnection 'sudo freeradius'

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host "  RestartFRD :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

StageAuthorizeCnfg
StageClientCnfg
TrnsfrStageCnfg
#RestartFRD
# end