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
  [string]$sourceRootDir = "/Users/mja/serve/MjA.SRC/",
  [string]$SkelDir = $sourceRootDir + "skel",
  [string]$XDir = $sourceRootDir + "x",
  [string]$brnchCmmtSKEL = "45047424",
  [string]$brnchCmmtX = "bd70fa4c",
  [string]$productbase = "mja/robot",
  [string]$verMajor = "99",
  [string]$verMinor = "0",
  [string]$verPatch = "0",
  [string]$verBld = "1",
  [string]$rcName = $verMajor + "." + $verMinor,
  [string]$verNum = $verMajor + "." + $verMinor + "." + $verPatch + "." + $verBld,
  [string]$rcTag = $verNum + "-qa"
)

function Rebase_Working_Copy {
  Write-Host "-= Rebase Working Copy    :: Started   =-"
  push-location $sourceRootDir

  rm -rf $SkelDir

  git clone https://github.com/serve-robotics/skel.git

  rm -rf $XDir

  git clone https://github.com/serve-robotics/x.git

  Pop-Location
  Write-Host "-= Rebase Working Copy    :: Completed =-"
}

function Gen_robot_branches {
  Write-Host "-= Generate Robot Branchges :: Started   =-"
  Write-Host "-= Release Name: $rcName            =-"
  
  #Rebase_Working_Copy
  
  push-location $SkelDir
  git checkout master
  git pull
  git branch $productbase/$rcName $brnchCmmtSKEL
  git checkout $productbase/$rcName
  $rvrVersion = "rover: `"$verNum`""
  (get-content -path release-manifest.yml -raw) -replace 'rover: "3.12.0"',$rvrVersion > release-manifesta.yml
  rm release-manifest.yml
  rename-item release-manifesta.yml release-manifest.yml
  git add release-manifest.yml && git commit -m “Release $rcTag” && git push origin $productbase/$rcName
  git tag $productbase/$rcTag && git push origin $productbase/$rcTag
  git push --set-upstream origin $productbase/$rcName
  Pop-Location
  
  push-location $XDir
  git checkout master
  git pull
  git branch $productbase/$rcName $brnchCmmtX
  git checkout $productbase/$rcName
  git push origin $productbase/$rcName
  git tag $productbase/$rcTag && git push origin $productbase/$rcTag
  git push --set-upstream origin $productbase/$rcName
  Pop-Location
  
  Write-Host "-= Generate Robot Branchges :: Completed =-"
}

<#
function Gen_fw_branches {
  Write-Host "-= Generate FLW Branchges :: Started   =-"
  Write-Host "-= Release Name: $rcName            =-"
  
  Rebase_Working_Copy

  push-location $SkelDir
  git branch release/fleetware/$rcName $brnchCmmtSKEL
  git switch release/fleetware/$rcName

  $flwVersion = "`"version`": `"$rcName`""
  push-location src/cloud/frontend/pilot/client
  (get-content -path package.json -raw) -replace '"version": "3.27.0"',$flwVersion > packagea.json
  rm package.json
  rename-item packagea.json package.json
  pop-location
  git add src/cloud/frontend/pilot/client/package.json && git commit -m “Release $rcName” && git push origin release/fleetware/$rcName
  git tag fleetware/$rcName && git push origin fleetware/$rcName

  Pop-Location
  
  Write-Host "-= Generate FLW Branchges :: Completed =-"
}
#>

Clear-Host

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Cutting the RC    =-"
Write-Host "-=     Starting:         =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

Gen_robot_branches
<# Gen_fw_branches #>

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=     Cutting the RC    =-"
Write-Host "-=     Completed:        =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Pop-Location
# end