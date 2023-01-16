#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; File to extract
file := A_ScriptDir . "\Th0q7eQ.rar"
; File containing the list of passwords
passwords := A_ScriptDir . "\passwords.txt"
; test file password is g>]C5L%2
output := A_ScriptDir . "\output.txt"

FormatTime, TimeString
FileDelete, %output%
FileAppend, `n%TimeString% `n , %output%
; MsgBox, %file%

; Read the list of passwords
Loop, read, %passwords%
{
    password = %A_LoopReadLine%
    command = ""C:\Program Files\WinRAR\unrar.exe" "t" "-p%password%" "%file%" >nul 2>>"%output%""
    
    FileAppend % "Trying: " . password . " ", %output%

    RunWait %A_ComSpec% /c %command% , , Hide
    returnedError := ErrorLevel
    ; result := RunWaitOne(command)
    ; FileAppend, %result%, %output%
    ; ExitApp, 
    FileAppend % " ErrorLevel: " . ErrorLevel . " `n", %output%
    if (returnedError == 0) {
        FileAppend % " `nPassword Found: " . password . " `n", %output%

        command = "C:\Program Files\WinRAR\winrar.exe" "-p%password%" "%file%"
        Run %command% 
                
        ExitApp
    }
}

if ErrorLevel != 0
    MsgBox, Password not found

ExitApp

