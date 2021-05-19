setlocal ENABLEDELAYEDEXPANSION
set i=0
:nextdriveletter
    subst "!OneDriveLetterEmulation:~%i%,1!:" "C:\ProgramData\onedrive"
    set /a i=i+1
    if "!OneDriveLetterEmulation:~%i%,1!" NEQ "" goto nextdriveletter