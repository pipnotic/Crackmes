include windows.inc 
include kernel32.inc
include user32.inc
include comdlg32.inc

include C:\masm32\macros\macros.asm

includelib	kernel32.lib
includelib user32.lib
includelib comdlg32.lib

; Prototypes
DlgProc					PROTO		:DWORD,:DWORD,:DWORD,:DWORD
HashMD5					PROTO
DecryptCode				PROTO		:DWORD

.const
IDD_CHALLENGE_TEN		EQU 			1001
IDC_EXIT 				EQU 			1006
IDC_HASH		 		EQU 			1009
IDC_DECRYPT_CODE 		EQU 			1011
IDC_RUN_CODE			EQU				1022
IDC_ABOUT				EQU				1023
ICON 					EQU 			2000
NERF					EQU				2001
HASH					EQU				2002


; Uninitialised data
.data?
hInstance					HINSTANCE 		?
hWindow					HWND			?
pMem					DWORD			?


; Initialised data
.data						
MD5Hash					BYTE 			32 DUP(0)
Hash					DWORD			4 DUP(0)
szAbout					BYTE			"OK, here we are again with a new series of challenges,"
						BYTE			" which will start with number 10.",0dh,0ah
						BYTE			"This time, you'll be forced to think out of the box, be creative.",0dh,0ah,0dh,0ah
						BYTE			"Here are the guidelines:",0dh,0ah,0dh,0ah
						BYTE			"- Find the number of Nerf darts",0dh,0ah
						BYTE			"- Find the hash (may not be obtainable now you think)",0dh,0ah
						BYTE			"- Generate the valid MD5 like so: MD5(<number of darts>:<valid hash>)",0dh,0ah
						BYTE			"- Enter the MD5 and press the ",22h,"Unlock",22h," button to decrypt the code",0dh,0ah
						BYTE			"- Press the ",22h,"Go",22h," button to see if you got it right. ",0dh,0ah
						BYTE			"- Verify your hash here: http://blog.sat0ri.com/challenges/ten/verify.php?hash=<your hash value>",0dh,0ah,0dh,0ah
						BYTE			"If you have any questions then post them in the forum at: http://blog.sat0ri.com/",0dh,0ah,0dh,0ah
						BYTE			"Have a blast!",0dh,0ah,0dh,0ah
						BYTE			"Regards,",0dh,0ah
						BYTE			"sharpe.",0dh,0ah,0dh,0ah
						BYTE			"Greets: Gunther, Deroko, EvilCry, Nicko, Jode, ARTeam, Marius,",0dh,0ah
						BYTE			"and of course, to all of the researchers at CERN",0
	