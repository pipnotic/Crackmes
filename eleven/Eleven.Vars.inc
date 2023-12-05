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

HashStruct STRUCT
	one 					DWORD			?
	two					DWORD			?
	three				DWORD			?
	four					DWORD			?
HashStruct ENDS


; Initialised data
.data						
MD5Hash					BYTE 			32 DUP(0)
Hash					DWORD			4 DUP(0)

HashTable				HashStruct		<0,0,0,0>
lHashTableLen			EQU				$ - HashTable

szAbout					BYTE			"Thanks for downloading challenge number 11 :o)",0dh,0ah,0dh,0ah
						BYTE			"Inspired by my last challenge, I made this one simpler yet more difficult.",0dh,0ah
						BYTE			"I made more of an effort with the encryption, which now uses 4 rotating dword keys",0dh,0ah
						BYTE			"instead of 1 static dword key. It should be more of a challenge. I removed all garbage code",0dh,0ah
						BYTE			"as well, so you can focus of the important stuff. I hope you like it.",0dh,0ah,0dh,0ah
						BYTE			"Here are the guidelines:",0dh,0ah
						BYTE			"- Find the correct key",0dh,0ah
						BYTE			"- Find the secret",0dh,0ah
						BYTE			"- Post feedback on the forum :o)",0dh,0ah,0dh,0ah
						BYTE			"If you have any questions then post them in the forum at: http://blog.sat0ri.com/",0dh,0ah,0dh,0ah
						BYTE			"I hope you enjoy this one.",0dh,0ah,0dh,0ah
						BYTE			"Regards,",0dh,0ah
						BYTE			"sharpe.",0dh,0ah,0dh,0ah
						BYTE			"Greets: Gunther, Deroko, EvilCry, Nicko, Jode, ARTeam, Marius, Stan Grof",0dh,0ah
						BYTE			"and of course, to all of the researchers at CERN",0
szSecret					BYTE 			10h,8Ch,15h,9Eh,0DDh,35h,2Bh,79h,20h,42h,5Eh,21h,01h,90h,0B9h,94h,09h,8Bh,52h,0D7h,9Bh,22h,69h,78h,25h,48h,5Bh
						BYTE			68h,55h,89h,0A5h,0D2h,5Dh,0CCh,5Fh,93h,9Eh,33h,38h,3Fh,6Fh,5Bh,53h,34h,45h,0C0h,0AAh,08Eh,4Ah,0D0h,56h,87h,0D4h,00h,0Bh,14h,0


lSecret					EQU				$ - szSecret