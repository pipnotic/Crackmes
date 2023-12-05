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
SerialTooShort BYTE "Your serial must be at least one byte!",0
SerialsNotEqual BYTE "Sorry but the entered values are incorrect!",0
Congratulations BYTE "Congratulations!",0
SerialsEqual BYTE "You have entered valid values!",0
AboutTitle BYTE "About",0
AboutText BYTE "Crackme #1 by sharpe",10,13
		BYTE "Difficulty: 1/10",0

.data? 
hInstance	HINSTANCE ?  
EnteredSerialBuffer BYTE 16 DUP(?)
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
			invoke GetDlgItemText,hWnd,IDC_NAME,addr NameBuffer,LENGTHOF NameBuffer+1
			cmp eax,1
			jge calculatehash
			invoke MessageBox,NULL,ADDR NameTooShort,ADDR Error,MB_OK
			jmp return		
			calculatehash:
			invoke lstrlen,ADDR NameBuffer
			invoke Round1,eax
			invoke GetDlgItemText,hWnd,IDC_SERIAL,addr EnteredSerialBuffer,LENGTHOF EnteredSerialBuffer+1 
			cmp eax,1
			jge comparestrings
			invoke MessageBox,NULL,ADDR SerialTooShort,ADDR Error,MB_OK
			jmp return
			comparestrings:
			push eax
			call CompareStrings
			;invoke SetDlgItemText,hWnd,IDC_SERIAL,addr SerialBuffer
		.elseif eax == IDC_COPY
			invoke SendDlgItemMessage,hWnd,IDC_SERIAL,EM_SETSEL,0,-1
			invoke SendDlgItemMessage,hWnd,IDC_SERIAL,WM_COPY,0,0
		.elseif eax == IDC_ABOUT
			invoke MessageBox,NULL,ADDR AboutText,ADDR AboutTitle,MB_OK
		.elseif eax == IDC_EXIT 
			invoke SendMessage,hWnd,WM_CLOSE,0,0
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog,hWnd,0
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

Upper PROC Char:DWORD
	LOCAL Temp:DWORD
	xor eax,eax
	mov ebx,2ef3a2d1h
	add eax,01011001h
	mov BYTE PTR[Temp],2dh
	mov bl,BYTE PTR[Temp]
	add al,bl
	mov BYTE PTR[Temp+1],3fh
	mov bl,BYTE PTR[Temp+1]
	add al,bl
	mov BYTE PTR[Temp+2],1fh
	mov bl,BYTE PTR[Temp+2]
	xor al,bl
	mov BYTE PTR[Temp+3],12h
	add BYTE PTR[Temp+3],bl
	mul ebx
	xchg eax,ebx
	and eax,ebx
	xchg al,bh
	xor al,bl
	sub eax,00001001b
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
		mov DWORD PTR[NameBuffer+eax],0
		mov DWORD PTR[SerialBuffer+eax],0
		mov DWORD PTR[EnteredSerialBuffer+eax],0
		add eax,4
		cmp ecx,eax
	jne @b
	Ret
CleanStrings EndP

CompareStrings PROC
	mov esi,DWORD PTR[SerialBuffer]
	mov edi,DWORD PTR[EnteredSerialBuffer]
	mov ecx,LENGTHOF NameBuffer
	xor eax,eax
	@@:
		mov bl,BYTE PTR[EnteredSerialBuffer+eax]
		cmp BYTE PTR[SerialBuffer+eax],bl
		jne badboy
		inc eax
		cmp ecx,eax
	jne @b
	invoke MessageBox,NULL,ADDR SerialsEqual,ADDR Congratulations,MB_OK
	jmp return
	badboy:
	invoke MessageBox,NULL,ADDR SerialsNotEqual,ADDR Error,MB_OK
	return:
	Ret
CompareStrings EndP

end start 


