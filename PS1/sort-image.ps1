<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  This script helps with sorting downloaded files from DA (DeviantArt) based on the submiter.
.INPUTS
  Script takes an input folder <sourceDir -- default is ~/Downloads>
  Script takes an output folder root <targetDirRoot -- default is ~/Downloads/DA.Art/Sorted>
.OUTPUTS
  Script generate an output folder with a folder for every Artist.
.NOTES
  Version:        -- see the GIT repos for version history
  Repos:          https://azriel.visualstudio.com/_git/scripts
  Author:         Mark Andrews
  Creation Date:  2/28/2017
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

Param(
  [string]$sourceDir = "/Users/usd42142/Downloads/",
  [string]$targetDirRoot = "/Users/usd42142/Downloads/DA.Art/Sorted/" 
)

Clear-Host
Push-Location $sourceDir

move-item *.zip ~/Downloads/CmPrsd/Z
move-item *.rar ~/Downloads/CmPrsd/R

gci -file | Rename-Item -NewName { $_.Name -replace "-fullview", "a" }
gci -file | Rename-Item -NewName { $_.Name -replace "_", "-" }
gci -file | Rename-Item -NewName { $_.Name -replace "-by-", "_by_" }

$filesMine = Get-ChildItem -Name
foreach ( $file in $filesMine ) {
  $file | Where-Object { $_ -match '(?<=_by_)(.*)(?=-)' } | foreach-object {
    $newPath = $targetDirRoot + $matches[0] + "/"
    If(!(test-path $newPath))
    {
      $newPath
      New-Item -type Directory -Force -Path $newPath
    }
    $fileName = "*" + $matches[0] + "*" 
    move-item $fileName $newPath
  }
}

Pop-Location
# end