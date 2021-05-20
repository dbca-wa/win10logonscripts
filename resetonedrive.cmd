@ECHO off
choice /m "Are you sure you want to reset your OneDrive desktop sync app? You won't lose any data by this reset process."
if %errorlevel% == 1 %localappdata%\Microsoft\OneDrive\onedrive.exe /reset
if %errorlevel% == 1 timeout /t 10
%localappdata%\Microsoft\OneDrive\onedrive.exe