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
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " PackageSrc :: Started"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"

  $tarTarget = $targetDirXfer + "4.0a.tar.gz"
  $tarTarget

  if (Test-Path -Path $tarTarget -PathType Leaf) {
    rm $tarTarget
  }

  push-location $sourceDirRoot
  tar -czvf $tarTarget 4.0a
  Pop-Location
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " PackageSrc :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-"
}

function XferFile {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " XferFile :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-"
  
  $tarTarget = $targetDirXfer + "4.0a.tar.gz"
  $tarTarget
  $debugTaregtDir
  
  # check for exisitng file / and remove it
  ssh build@khazadum "if [ -f drop/4.0a.tar.gz ]; then rm drop/4.0a.tar.gz; fi"

  # now transfer file 
  scp $tarTarget $debugTaregtDir
  
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " XferFile :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
}

function XtractFile {
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " XtractFile :: Started "
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-"
  
  # check for exisitng file and remove it / then unzip the file
  ssh build@khazadum "if [ -f drop/4.0a.tar ]; then rm drop/4.0a.tar; fi"
  ssh build@khazadum "gzip -f drop/4.0a.tar.gz"

  # check for exisitng file (working directory) and remove it / then untar it
  ssh build@khazadum "if [ -d 4.0a ]; then rm -rf 4.0a; fi"
  ssh build@khazadum "tar -xvf drop/4.0a.tar"

  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-"
  Write-Host " XtractFile :: Completed"
  Write-Host "-=-=-=-=-=-=-=-=-=-=-=-=-"
}

PackageSrc
XferFile
XtractFile

Pop-Location
# end