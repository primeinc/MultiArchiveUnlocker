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
; Delete previous output file
if(FileExist(output))
    FileDelete, %output%
FileAppend, `n%TimeString% `n , %output%

; Read the list of passwords
Loop, read, %passwords%
{
    password = %A_LoopReadLine%

    ; Command needs double quotes when using ComSpec, t - test the archive, p - password
    ; Standard Output is redirected to null, Standard Error is redirected to the output file
    command = ""C:\Program Files\WinRAR\unrar.exe" "t" "-p%password%" "%file%" >nul 2>>"%output%""
    
    ; Log the password used
    FileAppend % "Trying: " . password . " ", %output%

    ; Run the command
    RunWait %A_ComSpec% /c %command% , , Hide

    ; Assign the error level to a variable
    returnedError := ErrorLevel

    ; Log the error level
    FileAppend % " ErrorLevel: " . ErrorLevel . " `n", %output%

    ; If the error level is 0, the password was correct
    if (returnedError == 0) {
        ; Log the password found
        FileAppend % " `nPassword Found: " . password . " `n", %output%
        
        ; Run the command to open the file, without having to enter the password
        command = "C:\Program Files\WinRAR\winrar.exe" "-p%password%" "%file%"
        Run %command% 
                
        ExitApp
    }
}

if ErrorLevel != 0
    MsgBox, Password not found

ExitApp

