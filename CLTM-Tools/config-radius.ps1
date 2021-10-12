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


function StageConfig {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageConfig :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-"
  
  # check for exisitng file and remove it / then unzip the file
  $sshConnection = $trgtAccount + '@' + $trgtHost
  ssh $sshConnection "if [ -f stageauthorize ]; then rm stageauthorize; fi"
  
  #build text
  $testString = "`"" + $cyRadAccount + "\tCleartext-Password := \`"" + $cyRadPasswd + "\`"" + "\n\tReply-Message := \`"Authorized, %{User-Name}\`"" + "`""
  write-host $testString
  
  $sshCommand = "'echo -e " + $testString + ">> stageauthorize'"
  write-host $sshCommand

  ssh $sshConnection $sshCommand

  # check for exisitng file (working directory) and remove it / then untar it
  #ssh build@khazadum "if [ -d 4.0a ]; then rm -rf 4.0a; fi"
  #ssh build@khazadum "tar -xvf drop/4.0a.tar"

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " StageConfig :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

StageConfig

# end