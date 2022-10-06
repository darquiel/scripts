push-location ~/serve/SRC/skel
$PrList = gh pr list --search base:release/fleetware/3.32
# write-host $PrList
if ( $PrList -eq $null ) { Write-Host "No open PR's" } else { Write-Host "Open PR's" }
pop-location