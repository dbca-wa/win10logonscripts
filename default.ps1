# Run this script all the time for all users
Get-ExecutionPolicy > $env:userprofile/test-execpolicy.txt
$iselevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
write-output "iselevated: $iselevated"  >> $env:userprofile/test-execpolicy.txt
