# Run this script each logon elevated
$scriptdir = "C:\ProgramData\dbca-gitlogon"
Invoke-WebRequest -Uri https://github.com/dbca-wa/win10logonscripts/archive/refs/heads/main.zip -OutFile $scriptdir-repo.zip
Remove-Item $scriptdir\* -Recurse -Force
$ExtractShell = New-Object -ComObject Shell.Application 
$Files = $ExtractShell.Namespace("$scriptdir-repo.zip").Items() 
$ExtractShell.NameSpace($scriptdir).CopyHere($Files)
Move-Item $scriptdir\win10logonscripts-main\* $scriptdir\ -Force
mkdir $scriptdir/$env:username
Get-ExecutionPolicy > $scriptdir/$env:username/test-execpolicy.txt
$iselevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
write-output "iselevated: $iselevated"  >> $scriptdir/$env:username/test-execpolicy.txt

# Symlink onedrive folder
cmd.exe /c rmdir c:\ProgramData\onedrive
New-Item -ItemType Junction -Path C:\ProgramData\onedrive -Target $env:onedrive
