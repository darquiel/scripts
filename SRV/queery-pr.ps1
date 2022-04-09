<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  pr logging export from github
.INPUTS
  Script takes an input of src root
  Script takes an input of date range
.OUTPUTS
  Script generates a csv file with heading row for appropriate sorting
.NOTES
  Version:        -- see the GIT repos for version history
  Repos:          https://azriel.visualstudio.com/_git/scripts
  Author:         Mark Andrews
  Creation Date:  04/06/2022
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

Param(
  [string]$sourceSkelDir = "/Users/mja/serve/rover/skel/",
  [string]$sourceXDir = "/Users/mja/serve/rover/x/",
  [string]$targetLogDir = "/Users/mja/serve/"
)

Clear-Host
Push-Location $sourceDirRoot

function Generate_Skel_PR_Log {
  Write-Host "-= Generate SKEL PR Log   :: Started   =-"
  push-location $sourceSkelDir
  Write-Output "PR#`tDescription`tFrom branch" >> ~/serve/rover.csv
  gh pr list -L 100 -S "is:pr merged:2022-03-26..2022-04-08 base:master" >> ~/serve/rover.csv
  Pop-Location
  Write-Host "-= Generate SKEL PR Log   :: Completed =-"
}

function Generate_X_PR_Log {
  Write-Host "-= Generate X PR Log      :: Started   =-"
  push-location $sourceXDir
  gh pr list -L 100 -S "is:pr merged:2022-03-26..2022-04-08 base:master" 
  Pop-Location
  Write-Host "-= Generate X PR Log      :: Completed =-"
}



Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Exporting PR log from GitHub    =-"
Write-Host "-=     Starting:                       =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Generate_Skel_PR_Log
Generate_X_PR_Log

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Exporting PR log from GitHub    =-"
Write-Host "-=     Completed:                      =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Pop-Location
# end