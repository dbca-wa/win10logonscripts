# Script to pull repo from github, and run repo/default.ps1 on user login as an elevated scheduled task
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = "https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip"
if (!$(Test-Path $scriptdir)) { New-Item -ItemType Directory -Force -Path $scriptdir }
# Refresh scripts from repo
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir/update.zip"
Set-Location $scriptdir
Expand-Archive update.zip -Force
if (Test-Path "update\win10logonscripts-main\default.ps1") {
    # Only copy if unzip worked
    robocopy "$scriptdir\update\win10logonscripts-main" "$scriptdir\scripts" /MIR | Out-Null;
    Remove-Item update -Force -Recurse; # cleanup update dir
} else {
    Throw 'Script download failed...';
}
$Trigger = New-ScheduledTaskTrigger -AtLogon -User $env:username
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File $scriptdir\scripts\default.ps1"
Register-ScheduledTask -TaskName $env:username"_logon" -Trigger $Trigger -User $env:username -Action $Action -RunLevel Highest -Force
Start-ScheduledTask -TaskName $env:username"_logon"
