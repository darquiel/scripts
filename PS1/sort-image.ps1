<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  This script helps with sorting downloaded files from DA (DeviantArt) based on the submiter.
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  Script takes an input folder (default is ~/Downloads); and then generate an output folder with a folder for every Artist.
.OUTPUTS
  N/A
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

$filesMine = Get-ChildItem -Name
foreach ( $file in $filesMine ) {
  $file | Where { $_ -match '(?<=_by_)(.*)(?=-)' } | foreach {
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