# Script to pull repo from github, and run repo/default.ps1 on user login as an elevated scheduled task
$scriptdir = "C:\ProgramData\dbca-gitlogon"
New-Item -ItemType Directory -Force -Path $scriptdir
Invoke-WebRequest -Uri https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip -OutFile $scriptdir-repo.zip
Remove-Item $scriptdir\* -Recurse -Force
$ExtractShell = New-Object -ComObject Shell.Application 
$Files = $ExtractShell.Namespace("$scriptdir-repo.zip").Items() 
$ExtractShell.NameSpace($scriptdir).CopyHere($Files)
Move-Item $scriptdir\win10logonscripts-main\* $scriptdir\ -Force
$Trigger = New-ScheduledTaskTrigger -AtLogon -User $env:username
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File $scriptdir\default.ps1"
Register-ScheduledTask -TaskName $env:username"_logon" -Trigger $Trigger -User $env:username -Action $Action -RunLevel Highest -Force
