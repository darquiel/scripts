#New-Item -Path alias:VSCode -value 'open -a "Visual Studio Code"'
Set-Alias -name ls -value get-childitemcolor -option AllScope -Force
Set-Alias -name vscode -value start-visualstudiocode -option AllScope -Force

function Get-ChildItemColor {
<#
.Synopsis
  Returns childitems with colors by type.
.Description
  This function wraps Get-ChildItem and tries to output the results
  color-coded by type:
  Compressed - Yellow
  Directories - Dark Cyan
  Executables - Green
  Text Files - Cyan
  Others - Default
.ReturnValue
  All objects returned by Get-ChildItem are passed down the pipeline
  unmodified.
.Notes
  NAME:      Get-ChildItemColor
  AUTHOR:    Tojo2000 <tojo2000@tojo2000.com>
#>
  $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
      -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)

  $fore = $Host.UI.RawUI.ForegroundColor
  $compressed = New-Object System.Text.RegularExpressions.Regex(
      '\.(zip|tar|gz|rar)$', $regex_opts)
  $executable = New-Object System.Text.RegularExpressions.Regex(
      '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
  #$text_files = New-Object System.Text.RegularExpressions.Regex(
  #   '\.(txt|cfg|conf|ini|csv|log)$', $regex_opts)

  Invoke-Expression ("Get-ChildItem $args") |
    ForEach-Object{
      if ($_.Attributes -band [IO.FileAttributes]::Compressed) {
        #($_.GetType().Name -eq 'DirectoryInfo')
		$Host.UI.RawUI.ForegroundColor = 'Red'
        Write-output $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        $Host.UI.RawUI.ForegroundColor = 'DarkBlue'
        Write-output $_
        $Host.UI.RawUI.ForegroundColor = $fore
      }  elseif  ($_.Attributes -band [IO.FileAttributes]::Directory) {
        $Host.UI.RawUI.ForegroundColor = 'Blue'
        Write-output $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($compressed.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Red'
        Write-output $_
        $Host.UI.RawUI.ForegroundColor = $fore
	  } elseif ($executable.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Green'
        Write-output $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } else {
        Write-output $_
      }
    }
}

function start-visualstudiocode {
<# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
.DESCRIPTION
  Basic script to open VSCode with a particular file - to the GUI...
.NOTES
  Version:        1.0
  Author:         Mark Andrews
  Creation Date:  2/28/2017
  Purpose/Change: Initial script development 
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- #>

  Param(
    [string]$file2Edit = $PROFILE
  )

  # #New-Item -Path alias:VSCode -value 'open -a "Visual Studio Code"'
  $command = 'open -a "Visual Studio Code"' + " " + $file2Edit
  Invoke-Expression $command
  # end
}

set-location "~/scripts/PS1"
# clear