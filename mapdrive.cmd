@echo off

rem check for access to symlink
dir "%ProgramData%\onedrive" >null 2>&1
if %errorLevel% == 0 (
    subst "%1:" "%ProgramData%\onedrive"
) else (
    rem no access to symlink so fall back to onedrive directory
    subst "%1:" "%OneDriveCommercial%"
)
