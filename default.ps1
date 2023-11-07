# Run this script each logon elevated
$scriptdir = "$env:ProgramData\dbca-gitlogon"
$updatezip = "https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip"

# Refresh scripts from repo
Invoke-WebRequest -Uri $updatezip -OutFile "$scriptdir/update.zip"
Set-Location $scriptdir
Expand-Archive update.zip -Force
if (Test-Path "update\win10logonscripts-main\default.ps1") {
    # Only copy if unzip worked
    robocopy "$scriptdir\update\win10logonscripts-main" "$scriptdir\scripts" /MIR | Out-Null;
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
robocopy "$scriptdir\scripts\DBCA Utils" "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\DBCA Utils" /MIR | Out-Null;

# Update common software, only if installed
$installed = @()
# $installed = winget list
$updateifinstalled = @(
    'Google.Chrome',
    '7zip.7zip',
    'Oracle.JavaRuntimeEnvironment',
    'Mozilla.Firefox',
    'VideoLAN.VLC',
    'Adobe.AdobeAcrobatReaderDC',
    'Notepad++.Notepad++',
    'GIMP.GIMP',
    'Inkscape.Inkscape',
    'WinSCP.WinSCP',
    'FastStone.Viewer',
    'Zoom.Zoom',
    'Apple.iTunes',
    'Google.EarthPro'
)
ForEach ($app in $updateifinstalled) {
    if ($installed | findstr $app) {
        if ($($installed | findstr $app | findstr "winget")) {
            Write-Output "$app has an update, upgrading"
            winget install -e $app
        }
    }
}

New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Outlook\Preferences" -Name UseNewOutlook -Value 0 -Type DWord -Force
