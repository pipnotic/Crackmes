COMMENT !
Include files/libraries must be placed below
Please place other data in the appropriate section
!
include windows.inc 
include advapi32.inc
include kernel32.inc 
include user32.inc 
include msvcrt.inc

includelib	kernel32.lib
includelib	user32.lib 
includelib msvcrt.lib
includelib advapi32.lib

COMMENT !
Function prototypes must be placed here
Please create a prototype for each method even if it isn't 'invoked'
This will keep the prototypes consistant
!
DlgProc 			PROTO 			:DWORD,:DWORD,:DWORD,:DWORD 
HashName		PROTO			:DWORD
Round1 			PROTO 			:DWORD
CleanStrings 		PROTO 
CompareStrings 	PROTO
Obfuscate 		PROTO 			:DWORD
HashUnlockCode	PROTO
EnableDlgItems 	PROTO			:DWORD

COMMENT !
All uninitialised data must be placed here
Please use clear variable names
!
.data? 
hInstance			HINSTANCE 		? 
Version 			DWORD 			? 
UnlockCode 		BYTE 			16 DUP(?)
UnlockHash		BYTE			?
NameBuffer 		BYTE 			16 DUP(?) 
EnteredSerialBuffer	BYTE 			16 DUP(?)
NameHash		BYTE			?
SerialBuffer 		BYTE 			16 DUP(?)

COMMENT !
Initialised data must be placed here
Please use clear variable names
!
.data
Error 			BYTE 			"Error",0
WrongNameLen 	BYTE 			"Your name must be between 1 and 16 bytes!",0
SerialTooShort 	BYTE 			"Your serial must be at least one byte!",0
SerialsNotEqual 	BYTE 			"Sorry but the entered values are incorrect!",0
Congratulations 	BYTE 			"Congratulations",0
SerialsEqual 		BYTE 			"You have entered valid values!",0
AboutTitle 		BYTE 			"-=[ About",0
AboutText 		BYTE 			"Crackme #5 by sharpe - Difficulty: ?/10",10,13,10,13
				BYTE			"The serial-generation code in this crackme is obfuscated and there are no signatures this time.",10,13
				BYTE			"After the Unlock Code has been found, type it in and it will de-obfuscate the serial generation code.",10,13
				BYTE			"Then it should be straight forward.",10,13,10,13
				BYTE 			"Rules:",10,13
				BYTE			"- No patching",10,13
				BYTE 			"- Find the correct unlock code",10,13
				BYTE			"- Write a keygen",10,13
				BYTE 			"- Write a tutorial explaining how you solved this one and please include your code",10,13,10,13
				BYTE			"I really look forward to seeing your solutions!",0
UnlockCodeTitle	BYTE			"-=[ Unlock Code Error",0
UnlockCodeText	BYTE			"You have entered an invalid Unlock Code.",10,13
				BYTE			"Please try again.",0


COMMENT !
All constants must be placed here
This includes all dialog objects
Please use clear  names
!
.const
IDD_KEYGEN 		EQU 			1001
IDC_NAME 		EQU 			1002
IDC_SERIAL 		EQU 			1003
IDC_CHECK 		EQU 			1004
IDC_ABOUT 		EQU 			1005 
IDC_EXIT 		EQU 			1006
IDC_UNLOCKKEY 	EQU 			1009
IDC_UNLOCK 		EQU 			1011
ICON 			EQU 			2000
STATICKEY		EQU				2f9dh
