# Run this script each logon elevated
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = "https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip"

# Refresh scripts from repo
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir/update.zip"
Set-Location $scriptdir
Expand-Archive update.zip -ForceEx
if (Test-Path "update\win10logonscripts-main\default.ps1") {
    # Only update if zip extraction succeeded
    if (Test-Path scripts) { Remove-Item scripts -Recurse -Force };
    Move-Item update\* scripts -Force; Remove-Item update -Force;
}
Get-ExecutionPolicy > $scriptdir/$env:username-execpolicy.txt
$iselevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
write-output "iselevated: $iselevated"  >> $scriptdir/$env:username-execpolicy.txt

# Symlink onedrive folder
$staticonedrive = "$env:ProgramData\onedrive"
if (Test-Path $staticonedrive) { cmd.exe /c rmdir $staticonedrive };
New-Item -ItemType Junction -Path $staticonedrive -Target $env:OneDriveCommercial;

# Update shortcuts
robocopy "$scriptdir/scripts/DBCA Utils" "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\DBCA Utils" /MIR
