# Run this script each logon elevated
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = "https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip"

# Refresh scripts from repo
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir/update.zip"
Set-Location $scriptdir
Expand-Archive update.zip -Force
if (Test-Path scripts) { Remove-Item scripts -Recurse -Force }; Move-Item update\* scripts -Force; Remove-Item update -Force;
Get-ExecutionPolicy > $scriptdir/$env:username-execpolicy.txt
$iselevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
write-output "iselevated: $iselevated"  >> $scriptdir/$env:username-execpolicy.txt

# Symlink onedrive folder
$staticonedrive = "$env:ProgramData\onedrive"
if (Test-Path $staticonedrive) { cmd.exe /c rmdir $staticonedrive };
New-Item -ItemType Junction -Path $staticonedrive -Target $env:OneDriveCommercial;

# Update drive letter maps if set
$mapdrivescmd = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\driveletters.cmd";
Remove-Item $mapdrivescmd -Force;
New-Item $mapdrivescmd -Force;
foreach ($letter in $($($env:OneDriveLetterEmulation | Select-String -Pattern '^[A-Z]+$') -join "").toCharArray()) {
    Add-Content -Value "subst ${letter}: $staticonedrive" -Path $mapdrivescmd -Encoding ascii
}
