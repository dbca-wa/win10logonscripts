# Run this script each logon elevated
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = "https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip"

# Refresh scripts from repo
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir/update.zip"
Set-Location $scriptdir
Expand-Archive update.zip -Force
if (Test-Path "update\win10logonscripts-main\default.ps1") {
    # Only copy if unzip worked
    robocopy "$scriptdir\update\win10logonscripts-main" "$scriptdir\scripts" /MIR;
    Remove-Item update -Force -Recurse; # cleanup update dir
}
Get-ExecutionPolicy > $scriptdir/$env:username-execpolicy.txt
$iselevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
write-output "iselevated: $iselevated"  >> $scriptdir/$env:username-execpolicy.txt

# Symlink onedrive folder
$staticonedrive = "$env:ProgramData\onedrive"
if (Test-Path $staticonedrive) { cmd.exe /c rmdir $staticonedrive };
New-Item -ItemType Junction -Path $staticonedrive -Target $env:OneDriveCommercial;

# Update shortcuts
robocopy "$scriptdir\scripts\DBCA Utils" "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\DBCA Utils" /MIR;
