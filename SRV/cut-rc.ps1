<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.HEADER
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
  [string]$XDir = $sourceRootDir + "x",
  [string]$SkelDir = $sourceRootDir + "skel",
  [string]$brnchCmmtSKEL = "7e82a6a6",
  [string]$brnchCmmtX = "cbb51312",
  [string]$verNum = "3.28.0",
  [string]$rcNum = "rc1",
  [string]$rcName = $verNum + "-" + $rcNum
)

function Rebase_Working_Copy {
  Write-Host "-= Rebase Working Copy    :: Started   =-"
  push-location $sourceRootDir

  rm -rf $SkelDir
  git clone https://azriel.visualstudio.com/Learning/_git/skel

  rm -rf $XDir
  git clone https://azriel.visualstudio.com/Learning/_git/x

  Pop-Location
  Write-Host "-= Rebase Working Copy    :: Completed =-"
}

function Gen_rvr_branches {
  Write-Host "-= Generate RVR Branchges :: Started   =-"
  Write-Host "-= Release Name: $rcName            =-"
  
  Rebase_Working_Copy
  
  push-location $SkelDir
  git branch release/rover/$rcName $brnchCmmtSKEL
  git switch release/rover/$rcName
  $rvrVersion = "rover: `"$rcName`""
  (get-content -path release-manifest.yml -raw) -replace 'rover: "3.12.0"',$rvrVersion > release-manifesta.yml
  rm release-manifest.yml
  rename-item release-manifesta.yml release-manifest.yml
  
  git add release-manifest.yml && git commit -m “Release $rcName” && git push origin release/rover/$rcName

  Pop-Location
  
  #push-location $XDir
  #git branch release/rover/$rcName $brnchCmmtX
  #Pop-Location
  
  Write-Host "-= Generate RVR Branchges :: Completed =-"
}

function Gen_fw_branches {
  Write-Host "-= Generate RVR Branchges :: Started   =-"
  Write-Host "-= Release Name: $rcName            =-"
  
  Rebase_Working_Copy

  push-location $SkelDir
  git branch release/rover/$rcName $brnchCmmtSKEL
  Pop-Location
  
  Write-Host "-= Generate RVR Branchges :: Completed =-"
}

Clear-Host

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Cutting the RC    =-"
Write-Host "-=     Starting:         =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

Gen_rvr_branches


Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Cutting the RC    =-"
Write-Host "-=     Completed:        =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Pop-Location
# end