$ErrorActionPreference = 'Stop'
try {
    $url = 'https://fpdownload.macromedia.com/get/flashplayer/current/support/uninstall_flash_player.exe'
    $file = "$env:temp\uninstall_flash_player.exe"
    Invoke-WebRequest -Uri $url -OutFile $file
    cmd /c $file -uninstall
} catch {
    Write-Output $_ | Out-File $env:temp\flash_uninstall.log
}