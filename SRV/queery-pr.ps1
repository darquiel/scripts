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
  [string]$sourceSkelDir = "/Users/mja/serve/rvr/skel/",
  [string]$sourceXDir = "/Users/mja/serve/rvr/x/",
  [string]$sourceDirRoot = "/Users/mja/serve/"
)

Clear-Host
Push-Location $sourceDirRoot

function Rebase_Working_Copy {
  Write-Host "-= Rebase Working Copy    :: Started   =-"
  
  if (Test-Path -Path rvr) {
    remove-item -force -recurse rvr
  }
  
  new-item -type Directory rvr
  cd rvr

  git clone https://github.com/serve-robotics/skel.git
  git clone https://github.com/serve-robotics/x.git

  Pop-Location
  Write-Host "-= Rebase Working Copy    :: Completed =-"
}

function Generate_Skel_PR_Log {
  if (Test-Path -Path ~/serve/roverSkel.csv -PathType Leaf) {
    remove-item ~/serve/roverSkel.csv
  }

  Write-Host "-= Generate SKEL PR Log   :: Started   =-"
  push-location $sourceSkelDir
  Write-Output "PR#`tDescription`tFrom branch" >> ~/serve/roverSkel.csv
  gh pr list -L 100 -S "is:pr merged:2022-04-23..2022-05-06 base:master" >> ~/serve/roverSkel.csv
  Pop-Location
  Write-Host "-= Generate SKEL PR Log   :: Completed =-"
}

function Generate_X_PR_Log {
  Write-Host "-= Generate X PR Log      :: Started   =-"
  if (Test-Path -Path ~/serve/roverx.csv -PathType Leaf) {
    remove-item ~/serve/roverx.csv
  }
  push-location $sourceXDir
  Write-Output "PR#`tDescription`tFrom branch" >> ~/serve/roverx.csv
  gh pr list -L 100 -S "is:pr merged:2022-04-23..2022-05-06 base:master" >> ~/serve/roverx.csv
  Pop-Location
  Write-Host "-= Generate X PR Log      :: Completed =-"
}



Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Exporting PR log from GitHub    =-"
Write-Host "-=     Starting:                       =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

Rebase_Working_Copy
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