# Script to pull repo from github, and run repo/default.ps1 on user login as an elevated scheduled task
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = "https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip"
if (Test-Path $scriptdir) { Remove-Item $scriptdir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $scriptdir
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir/update.zip"
Set-Location $scriptdir
Expand-Archive update.zip -Force
if (Test-Path scripts) { Remove-Item scripts -Recurse -Force }; Move-Item update\* scripts -Force; Remove-Item update -Force;
$Trigger = New-ScheduledTaskTrigger -AtLogon -User $env:username
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File $scriptdir\scripts\default.ps1"
Register-ScheduledTask -TaskName $env:username"_logon" -Trigger $Trigger -User $env:username -Action $Action -RunLevel Highest -Force
