#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; File to extract
file = "C:\path\to\file.rar"

; File containing the list of passwords
passwords = "C:\path\to\passwords.txt"

; Read the list of passwords
Loop, read, %passwords%
{
    password = %A_LoopReadLine%
    Run, "C:\Program Files\WinRAR\WinRAR.exe" x -p%password% %file%
    if ErrorLevel == 0
    {
        MsgBox, Password found: %password%
        break
    }
    Run, "C:\Program Files\7-Zip\7z.exe" x -p%password% %file%
    if ErrorLevel == 0
    {
        MsgBox, Password found: %password%
        break
    }
}

if ErrorLevel != 0
    MsgBox, Password not found
