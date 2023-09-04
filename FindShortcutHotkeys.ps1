## Enum-ShortcutHotkeys.ps1
# Function from Tim Lewis https://stackoverflow.com/a/21967566/6811411
function Get-Shortcut {
  param(
    $path = $null
  )
  $obj = New-Object -ComObject WScript.Shell
  if ($path -eq $null) {
    $pathUser = [System.Environment]::GetFolderPath('StartMenu')
    $pathCommon = $obj.SpecialFolders.Item('AllUsersStartMenu')
    $path = dir $pathUser, $pathCommon -Filter *.lnk -Recurse 
  }
  if ($path -is [string]) {$path = dir $path -Filter *.lnk}
  $path | ForEach-Object { 
    if ($_ -is [string]) {$_ = dir $_ -Filter *.lnk}
    if ($_) {
      $link = $obj.CreateShortcut($_.FullName)
      $info = @{}
      $info.Hotkey = $link.Hotkey
      $info.TargetPath = $link.TargetPath
      $info.LinkPath = $link.FullName
      $info.WorkingDirectory = $link.WorkingDirectory
      $info.Arguments = $link.Arguments
      $info.Target = try {Split-Path $info.TargetPath -Leaf } catch { 'n/a'}
      $info.Link = try { Split-Path $info.LinkPath -Leaf } catch { 'n/a'}
      $info.Description = $link.Description
      $info.WindowStyle = $link.WindowStyle
      $info.IconLocation = $link.IconLocation
      New-Object PSObject -Property $info
    }
  }
}
Get-ChildItem -path c:\ -filter *.lnk -rec -force -EA 0|
  ForEach-Object {
    get-shortcut $_.FullName|where Hotkey
  }