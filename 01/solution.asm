.386 
.model flat,stdcall 
option casemap:none 

include windows.inc 
include kernel32.inc 
include user32.inc 
includelib	kernel32.lib
includelib	user32.lib 

DlgProc PROTO :DWORD,:DWORD,:DWORD,:DWORD 
Round1 PROTO :DWORD 

.data
Error BYTE "Error",0
NameTooShort BYTE "Your name must be at least one byte!",0
SerialsEqual BYTE "You have entered valid values!",0
AboutTitle BYTE "About",0
AboutText BYTE "Crackme #2 solution by sharpe",10,13
		BYTE "Difficulty: 1/10",0

.data? 
hInstance	HINSTANCE ?  
NameBuffer BYTE 16 DUP(?) 
SerialBuffer BYTE 16 DUP(?)

.const
IDD_KEYGEN equ 1001
IDC_NAME equ 1002
IDC_SERIAL equ 1003
IDC_GENERATE equ 1004
IDC_COPY equ 1005 
IDC_EXIT equ 1006
IDC_ABOUT equ 1009
ICON equ 2000

.code 
start: 
    invoke GetModuleHandle, NULL 
    mov hInstance,eax 
    invoke DialogBoxParam, hInstance, IDD_KEYGEN, NULL, addr DlgProc, NULL 
    invoke ExitProcess,eax 
    
DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
.if uMsg == WM_INITDIALOG
	invoke LoadIcon,hInstance,ICON
	invoke SendMessage,hWnd,WM_SETICON,1,eax
	invoke GetDlgItem,hWnd,IDC_NAME
	invoke SetFocus,eax 
.elseif uMsg == WM_COMMAND
	mov	eax,wParam
	.if eax == IDC_GENERATE
		invoke GetDlgItemText,hWnd,IDC_NAME,addr NameBuffer,32
		cmp eax,1
		jge calculatehash
		invoke MessageBox,NULL,ADDR NameTooShort,ADDR Error,MB_OK
		jmp return		
		calculatehash:
		invoke lstrlen,ADDR NameBuffer
		invoke Round1,eax
		invoke SetDlgItemText,hWnd,IDC_SERIAL,addr SerialBuffer
	.elseif eax == IDC_ABOUT
		invoke MessageBox,NULL,ADDR AboutText,ADDR AboutTitle,MB_OK
	.elseif eax == IDC_EXIT 
		invoke SendMessage,hWnd,WM_CLOSE,0,0
	.endif
.elseif uMsg == WM_CLOSE
	invoke EndDialog,hWnd,1
.endif
	return:
	call CleanStrings
    	xor eax,eax
    	ret 
DlgProc endp 

Round1 PROC NameLen:DWORD
	mov esi,OFFSET NameBuffer
	mov edi,OFFSET SerialBuffer
	mov ecx,LENGTHOF SerialBuffer
	@@:
		movzx eax,BYTE PTR[esi]
		push ecx
		push eax
		call Upper
		mov DWORD PTR[edi],eax
		inc edi
		inc esi
	loop @b
	Ret
Round1 EndP

Upper PROC Char:DWORD,Position:DWORD
	mov eax,Char
	add eax,00000001b
	mov eax,Char
	add eax,ecx
	cmp eax,21h
	jae checkhigh
	add eax,21h
	checkhigh:
	cmp eax,7bh
	jle nothighbit
	shr eax,1
	nothighbit:
	mov Char,eax
	mov eax,Char
	Ret
Upper EndP

CleanStrings proc
	mov ecx,LENGTHOF NameBuffer
	xor eax,eax
	@@:
		mov DWORD PTR[NameBuffer+eax],00000000h
		mov DWORD PTR[SerialBuffer+eax],00000000h
		add eax,4
		cmp ecx,eax
	jne @b
	Ret
CleanStrings EndP

end start 


