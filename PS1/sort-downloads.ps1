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
  [string]$sourceDir = "/Users/mja/Downloads/",
  [string]$targetCmPrsdDirRoot = "/Users/mja/OneDrive/Downloads/CmPrsd/", 
  [string]$targetImageDirRoot = "/Users/mja/OneDrive/Downloads/DA.Art/Sorted/",
  [string]$targetInstallersDirRoot = "/Users/mja/OneDrive/Downloads/Installer/",
  [string]$targetAudioDirRoot = "/Users/mja/OneDrive/Downloads/Audio/",
  [string]$targetExecDirRoot = "/Users/mja/OneDrive/Downloads/MRA/You-Exec/" 
)

Clear-Host
Push-Location $sourceDir

function MoveCompressedFiles {
  Write-Host "-= MoveCompressedFiles    :: Started   =-"
  $zDir = $targetCmPrsdDirRoot + "Z/"
  $rDir = $targetCmPrsdDirRoot + "R/"
  $tgzDir = $targetCmPrsdDirRoot + "tar.gz/"
  $isoDir = $targetCmPrsdDirRoot + "ISO/"
  Move-Item *.zip $zDir 
  Move-Item *.rar $rDir
  Move-Item *.tar.gz $tgzDir
  Move-Item *.iso $isoDir
  Write-Host "-= MoveCompressedFiles    :: Completed =-"
}

function MoveInstallers {
  Write-Host "-= MoveInstallers         :: Started   =-"
  $pkgDir = $targetInstallersDirRoot + "PKG/"
  $dmgDir = $targetInstallersDirRoot + "DMG/"
  Move-Item *.pkg $pkgDir
  Move-Item *.dmg $dmgDir
  Write-Host "-= MoveInstallers         :: Completed =-"
}

function MoveAudioFiles {
  Write-Host "-= MoveAudioFiles         :: Started   =-"
  $audioDir = $targetAudioDirRoot
  
  Move-Item *.mp3 $audioDir
  Write-Host "-= MoveAudioFiles         :: Completed =-"
}
function MoveExecFiles {
  Write-Host "-= MoveExecFiles          :: Started   =-"
  $pptxDir = $targetExecDirRoot + "PPTX/"
  $xlsDir = $targetExecDirRoot + "XLS/"
  $keyDir = $targetExecDirRoot + "KEY/"
  Move-Item *.pptx $pptxDir
  Move-Item *.xls $xlsDir
  Move-Item *.xlsx $xlsDir
  Move-Item *.key $keyDir
  Write-Host "-= MoveExecFiles          :: Completed =-"
}

function CleanFilenames {
  Write-Host "-= CleanFilenames         :: Started   =-"
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "-fullview", "a" }
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "_", "-" }
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "-by-", "_by_" }
  Write-Host "-= CleanFilenames         :: Completed =-"
}

function SortImages {
  Write-Host "-= SortImages             :: Started   =-"
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
      Move-Item $fileName $newPath
    }
  }
  Write-Host "-= SortImages             :: Completed =-"
}

Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=      Processing Downloads Folder    =-"
Write-Host "-=      Starting:                      =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
MoveCompressedFiles
CleanFilenames
SortImages
MoveExecFiles
MoveInstallers
MoveAudioFiles
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host "-=      Processing Downloads Folder    =-"
Write-Host "-=      Completed:                     =-"
Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
Write-Host ""

Pop-Location
# end