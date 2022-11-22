<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.HEADER
  .DESCRIPTION
    Trigger-HITL build
  .INPUTS
    Script takes an input branch to build
    Script takes an input of drone user token
  .OUTPUTS
   Script Triggers the build via drone & OBD
  .NOTES
   Version:        -- see the GIT repos for version history
   Repos:          https://azriel.visualstudio.com/_git/scripts/SRV
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

Param(
  [string]$brnchName = "master",
  [string]$CRON_NAME = "manual",
  [string]$drnToken = "GkpgQqOgYZNmC78q49g6a8qpNyRkq3za",
  [string]$drnServer = "http://drone.internal.0x78.xyz"
)

function Display_Usage {
  $scriptName = & { $myInvocation.ScriptName }
  Write-Host "USAGE`n"
  Write-Host "$scriptName <BRANCH_NAME> <DRONE_TOKEN>"
  Write-Host "ex:`n$scriptName $brnchName $drnToken`n`n`n"
}

function Create_cron_job {
  # The "0 0 * * * *" string represents the cron job schedule of every hour
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  write-host "drone cron add serve-robotics/skel "$CRON_NAME" "0 0 * * * *" --branch "$brnchName""
  sleep 1
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function Trigger_build {
  Write-Host "`n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  write-host "curl -s -X POST -H "Authorization: Bearer $DRONE_TOKEN" -H "Content-length: 0" "$SERVER/api/repos/serve-robotics/skel/cron/$CRON_NAME""
  sleep 1
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function Cleanup_cron_jobs{
  Write-Host "`n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  write-host "drone cron rm serve-robotics/skel $CRON_NAME 2> /dev/null"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

Clear-Host

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=    Triggering HITL    =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"

Display_Usage
Create_cron_job
Trigger_build
Cleanup_cron_jobs

Write-Host ""

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Completed:        =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Pop-Location
# end


