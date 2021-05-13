# Run this script each logon elevated
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip

# Refresh scripts from repo
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir.zip"
Expand-Archive -Path $scriptdir.zip -DestinationPath $scriptdir -Force
Remove-Item $scriptdir\scripts -Recurse -Force; Move-Item $scriptdir\win10logonscripts-main $scriptdir\scripts -Force
Get-ExecutionPolicy > $scriptdir/$env:username-execpolicy.txt
$iselevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
write-output "iselevated: $iselevated"  >> $scriptdir/$env:username-execpolicy.txt

# Symlink onedrive folder
$staticonedrive = "$env:ProgramData\onedrive"
if (!(Test-Path $staticonedrive)) { New-Item -ItemType Junction -Path $staticonedrive -Target $env:OneDriveCommercial };

# Update drive letter maps if set
$mapdrivescmd = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\driveletters.cmd";
Remove-Item $mapdrivescmd -Force;
foreach ($letter in $($($env:OneDriveLetterEmulation | Select-String -Pattern '^[A-Z]+$') -join "").toCharArray()) {
    write-output "subst ${letter}: $staticonedrive" >> $mapdrivescmd
}
