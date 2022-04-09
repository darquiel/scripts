<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  Generate RC
.INPUTS
  Script takes an input of src root
  Script takes an input of rc to cut
  option flag {for RVR, FLT, ALL}
.OUTPUTS
  Script automates actions for generating an RC
.NOTES
  Version:        -- see the GIT repos for version history
  Repos:          https://azriel.visualstudio.com/_git/scripts/SRV
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

Param(
  [string]$sourceRootDir = "/Users/mja/serve/test/",
  [string]$XDir = $sourceRotoDir + "/rover/x/",
  [string]$SkelDir = "/rover/skel/"
)

function Rebase_Working_Copy {
  Write-Host "-= Rebase Working Copy  :: Started   =-"
  push-location $sourceRootDir
  #Write-Output "PR#`tDescription`tFrom branch" >> ~/serve/rover.csv
  #gh pr list -L 100 -S "is:pr merged:2022-03-26..2022-04-08 base:master" >> ~/serve/rover.csv
  gci
  Pop-Location
  Write-Host "-= Rebase Working Copy  :: Completed =-"
}

Clear-Host

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Cutting the RC    =-"
Write-Host "-=     Starting:         =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

Rebase_Working_Copy
#Generate_X_PR_Log

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Cutting the RC    =-"
Write-Host "-=     Completed:        =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Pop-Location
# end