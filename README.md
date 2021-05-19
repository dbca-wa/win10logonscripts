# win10logonscripts
Windows 10 logon scripts to simplify drive emulation and printer mappings

This can be deployed by creating `IntuneGitLogon.ps1` as a 'user assigned' powershell script, that will execute the `default.ps1` script from the `$updatezip` which is redownloaded on each logon.
