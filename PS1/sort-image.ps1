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
  [string]$targetCmPrsdDirRoot = "/Users/usd42142/OneDrive/Downloads/CmPrsd/", 
  [string]$targetImageDirRoot = "/Users/usd42142/OneDrive/Downloads/DA.Art/Sorted/",
  [string]$targetExecDirRoot = "/Users/usd42142/OneDrive/Downloads/MRA/You-Exec/" 
)

Clear-Host
Push-Location $sourceDir

function MoveCompressedFiles {
  $zDir = $targetCmPrsdDirRoot + "Z/"
  $rDir = $targetCmPrsdDirRoot + "R/"
  move-item *.zip $zDir 
  move-item *.rar $rDir
  Write-Host "MoveCompressedFiles :: Completed"
}

function MoveExecFiles {
  $pptxDir = $targetExecDirRoot + "PPTX/"
  $xlsDir = $targetExecDirRoot + "XLS/"
  move-item *.pptx $pptxDir
  move-item *.xls $xlsDir
  Write-Host "MoveExecFiles :: Completed"
}

function CleanFilenames {
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "-fullview", "a" }
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "_", "-" }
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "-by-", "_by_" }
  write-host "CleanFilenames :: Completed"
}

function SortImages {
  $filesMine = Get-ChildItem -Name
  foreach ( $file in $filesMine ) {
    $file | Where-Object { $_ -match '(?<=_by_)(.*)(?=-)' } | foreach-object {
      $newPath = $targetImageDirRoot + $matches[0] + "/"
      If(!(test-path $newPath))
      {
        $newPath
        New-Item -type Directory -Force -Path $newPath
      }
      $fileName = "*" + $matches[0] + "*" 
      move-item $fileName $newPath
    }
  }
  write-host "SortImages :: Completed"
}

MoveCompressedFiles
CleanFilenames
SortImages
MoveExecFiles

Pop-Location
# end