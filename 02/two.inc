COMMENT !
Include files/libraries must be placed below
Please place other data in the appropriate section
!
include 			windows.inc 
include 			kernel32.inc 
include 			user32.inc 
include 			msvcrt.inc

includelib			kernel32.lib
includelib			user32.lib 
includelib 		msvcrt.lib

COMMENT !
Function prototypes must be placed here
Please create a prototype for each method even if it isn't 'invoked'
This will keep the prototypes consistant
!
DlgProc 			PROTO 		:DWORD,:DWORD,:DWORD,:DWORD 
HandleCommand 	PROTO
Round1 			PROTO 
Round2 			PROTO 		:BYTE
Round3 			PROTO 		:DWORD
CleanStrings 		PROTO 
CompareStrings 	PROTO
CheckForDbg 		PROTO

COMMENT !
Structures and unions must be declared here
!
SKEYCHAIN 		STRUCT
	First BYTE ?
	Second BYTE ?
	Third BYTE ?
SKEYCHAIN EndS 

COMMENT !
All uninitialised data must be placed here
Please use clear variable names
!
.data? 
hInstance			HINSTANCE 	? 
Version 			DWORD 		? 
EnteredSerialBuffer 	BYTE 		16 DUP(?)
NameBuffer 		BYTE 		16 DUP(?) 
SerialBuffer 		BYTE 		16 DUP(?)

COMMENT !
Initialised data must be placed here
Please use clear variable names
!
.data
Format 			BYTE 		"%d",0
Error 			BYTE 		"Error",0
WrongNameLen 	BYTE 		"Your name must be between 1 and 16 bytes!",0
SerialTooShort 	BYTE 		"Your serial must be at least one byte!",0
SerialsNotEqual 	BYTE 		"Sorry but the entered values are incorrect!",0
Congratulations 	BYTE 		"Congratulations",0
SerialsEqual 		BYTE 		"You have entered valid values!",0
AboutTitle 		BYTE 		"-=[ About",0
AboutText 		BYTE 		"Crackme #2 by sharpe - Difficulty: 2/10",10,13,10,13
				BYTE 		"Rules:",10,13
				BYTE 		"- Write a keygen or find a valid username/serial",0
Keys SKEYCHAIN 	<23h,4fh,0efh>	


COMMENT !
All constants must be placed here
This includes all dialog objects
Please use clear  names
!
.const
IDD_KEYGEN 		equ 			1001
IDC_NAME 		equ 			1002
IDC_SERIAL 		equ 			1003
IDC_CHECK 		equ 			1004
IDC_ABOUT 		equ 			1005 
IDC_EXIT 		equ 			1006
ICON 			equ 			2000
