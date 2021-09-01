<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  helper script to package and x-fer to debugging server for CYSRC project
.INPUTS
  Script takes an input folder <sourceDir -- default is ~/Cylentium/cysrc>
  Script takes ax xfer folder xfer <targetDirxfer -- default is ~/Cylentium/drop>
.OUTPUTS
  Script generate an xfer folder w/ tar.gz file and transfers it to the target machine <debug target>
.NOTES
  Version:        -- see the GIT repos for version history
  Repos:          https://azriel.visualstudio.com/_git/scripts
  Author:         Mark Andrews
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

Param(
  [string]$sourceDirRoot = "/Users/mja/work/Cylentium/",
  [string]$targetDirXfer = "/Users/mja/work/Cylentium/drop/", 
  [string]$debugTaregtDir = "build@khazadum:/home/build/drop" 
)

Clear-Host
Push-Location $sourceDir

function PackageSrc {
  $tarTarget = $targetDirXfer + "4.0a.tar.gz"
  $tarTarget

  if (Test-Path -Path $tarTarget -PathType Leaf) {
    rm $tarTarget
  }

  push-location $sourceDirRoot
  tar -czvf $tarTarget 4.0a
  Write-Host "PackageSrc :: Completed"
  Pop-Location
}

function XferFile {
  $tarTarget
  $debugTaregtDir
  scp ~/work/Cylentium/drop/4.0a.tar.gz build@khazadum:/home/build/drop
  # $scp $tarTarget $debugTaregtDir
  Write-Host "XferFile :: Completed"
}

<# function CleanFilenames {
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "-fullview", "a" }
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "_", "-" }
  Get-ChildItem -file | Rename-Item -NewName { $_.Name -replace "-by-", "_by_" }
  write-host "CleanFilenames :: Completed"
} #>

<# function SortImages {
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
} #>

PackageSrc
XferFile
#SortImages
#MoveExecFiles

Pop-Location
# end