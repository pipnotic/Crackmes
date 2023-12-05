COMMENT !	
Programme options are specified below
Unlock COde: jhGtrr456fRes
!
.486
.model flat,stdcall
option casemap:none

COMMENT !
Programme includes are specified here
Please place all prototypes and global varialbes in the include file below
!
include four.inc

.code 
start: 

call CheckForDbg
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
		invoke GetVersion
		mov Version,eax
		call CheckForDbg
	.elseif uMsg == WM_COMMAND
		call CheckForDbg
		mov	eax,wParam
		.if eax == IDC_UNLOCK
			invoke GetDlgItemText,hWnd,IDC_UNLOCKKEY,ADDR UnlockCode,SIZEOF UnlockCode+1
			.if eax>0
				invoke Obfuscate,hWnd,ADDR UnlockCode
				mov ebx,OFFSET @begin
				cmp DWORD PTR[ebx],0e8ec8b55h
				jnz @InvalidUnlockCode
				cmp DWORD PTR[ebx+4],000001cah
				jnz @InvalidUnlockCode
				cmp DWORD PTR[ebx+8],4868116ah
				jnz @InvalidUnlockCode			
				invoke EnableDlgItems,hWnd
				jmp @return
				@InvalidUnlockCode:
				invoke MessageBox,hWnd,ADDR UnlockCodeText,ADDR UnlockCodeTitle,MB_ICONWARNING
				invoke GetDlgItemText,hWnd,IDC_UNLOCKKEY,ADDR UnlockCode,SIZEOF UnlockCode+1
				invoke Obfuscate,hWnd,ADDR UnlockCode
			.else
				invoke MessageBox,hWnd,ADDR UnlockCodeText,ADDR UnlockCodeTitle,MB_ICONWARNING
			.endif
		.elseif eax == IDC_CHECK
			invoke ValidateCredentials,hWnd
		.elseif eax == IDC_ABOUT
			invoke MessageBox,hWnd,ADDR AboutText,ADDR AboutTitle,MB_OK
		.elseif eax==IDC_EXIT
			invoke SendMessage,hWnd,WM_CLOSE,0,0
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog,hWnd,0
	.endif
	@return:
	invoke CleanStrings
    	xor eax,eax
    	ret 
DlgProc endp 

nop
nop
nop
@begin:

ValidateCredentials PROC hWnd:DWORD
	call CheckForDbg
	invoke GetDlgItemText,DWORD PTR [EBP+8],IDC_NAME,ADDR NameBuffer,SIZEOF NameBuffer+1
	cmp eax,1
	jge gt1
	invoke MessageBox,NULL,ADDR WrongNameLen,ADDR Error,MB_OK
	jmp return		
	gt1:
	cmp eax,10h
	jle lt16
	invoke MessageBox,NULL,ADDR WrongNameLen,ADDR Error,MB_OK
	jmp return
	lt16:
	call Round1
	invoke lstrlen,ADDR NameBuffer
	push eax			
	call Round3
	invoke GetDlgItemText,DWORD PTR [EBP+8],IDC_SERIAL,ADDR EnteredSerialBuffer,SIZEOF EnteredSerialBuffer+1
	cmp eax,1
	jge comparestrings
	invoke MessageBox,NULL,ADDR SerialTooShort,ADDR Error,MB_OK
	jmp return
	comparestrings:
	call CompareStrings
	;invoke SetDlgItemText,DWORD PTR [EBP+8],IDC_SERIAL,ADDR SerialBuffer
	return:
	Ret
ValidateCredentials EndP

Round1 PROC
	mov esi,OFFSET NameBuffer
	mov edi,OFFSET SerialBuffer
	mov ecx,SIZEOF SerialBuffer
	mov ebx,Version
	@@:
		mov al,BYTE PTR[esi]
		cmp al,0
		jne al_notnull
		cmp cl,0
		jne cl_notnull
		mov al,39h
		cl_notnull:
		mov al,cl
		al_notnull:
		xor al,bl
		xchg bl,bh
		xor al,bl
		push eax
		call Round2
		mov BYTE PTR[edi],al
		inc esi
		inc edi
	loop @b
	Ret
Round1 EndP

Round2 PROC Char:BYTE
	mov al,BYTE PTR[ebp+8]
	xor al,Keys.First
	xor al,Keys.Second
	xor al,Keys.Third
	Ret
Round2 EndP

Round3 PROC NameLen:DWORD
	LOCAL LowBit:BYTE
	mov esi,OFFSET NameBuffer
	mov edi,OFFSET SerialBuffer
	mov ecx,SIZEOF SerialBuffer
	mov LowBit,0
	@@:
		mov al,BYTE PTR[esi]
		cmp al,00h
		jnz next
		mov al,3fh
		next:
		mul cl
		push ecx
		xor ecx,ecx
		mov ecx,NameLen
		inner:
			mov bl,BYTE PTR[esi+ecx-1]
			xor al,bl
			dec ecx
		jnz inner
		pop ecx
		mov bl,LowBit
		cmp bl,1
		jl low_bit
		and al,0f0h
		shr al,4
		jmp high_bit
		low_bit:
		and al,0fh
		high_bit:
		neg bl
		mov LowBit,bl		
		cmp al,9
		jle no_xtra
		add al,7
		no_xtra:
		add al,30h
		mov BYTE PTR[edi],al
		inc edi
		inc esi
	loop @b
	Ret
Round3 EndP

@end:
nop
nop
nop
nop


CleanStrings PROC
	mov ecx,SIZEOF NameBuffer
	xor eax,eax
	COMMENT !
	; This will do the same
	mov edi,OFFSET NameBuffer
	cld
	rep stosd
	!
	@@:
		mov DWORD PTR[EnteredSerialBuffer+eax],0
		mov DWORD PTR[NameBuffer+eax],0
		mov DWORD PTR[SerialBuffer+eax],0
		mov DWORD PTR[UnlockCode+eax],0
		add eax,4
		cmp ecx,eax
	jne @b
	Ret
CleanStrings EndP

CompareStrings PROC
	mov esi,OFFSET SerialBuffer
	mov edi,OFFSET EnteredSerialBuffer
	mov ecx,SIZEOF SerialBuffer
	xor eax,eax
	@@:
		mov bl,BYTE PTR[EnteredSerialBuffer+eax]
		cmp BYTE PTR[SerialBuffer+eax],bl
		jne return
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

CheckForDbg PROC
	xor eax,eax
	invoke IsDebuggerPresent
	cmp eax,0
	jz return
	invoke ExitProcess,NULL
	return:
	Ret
CheckForDbg EndP

Obfuscate PROC hWnd:DWORD,Key:DWORD
	sub esp,4
	invoke lstrlen,Key
	mov DWORD PTR[ebp-4],eax
	.if DWORD PTR[ebp-4]<=1
		invoke MessageBox,hWnd,ADDR UnlockCodeText,ADDR UnlockCodeTitle,MB_ICONEXCLAMATION
	.else
		mov esi,Key
		xor eax,eax
		xor ebx,ebx
		mov ecx,DWORD PTR[ebp-4]
		@hashkey:
			mov al,BYTE PTR[esi]
			mov ebx,STATICKEY
			xor al,bl
			xor al,bh
			mov BYTE PTR[esi],al
			inc esi
			dec ecx
		jnz @hashkey		
		mov eax,OFFSET @begin
		mov ecx,OFFSET @end-3
		sub ecx,eax
		xor ebx,ebx
		@outer:
			mov dl,BYTE PTR[ebx+eax]
			push eax
			xor eax,eax
			push ecx
			mov ecx,DWORD PTR[ebp-4]
			mov esi,Key
			@inner:
				xor dl,BYTE PTR[esi]
				inc esi
				dec ecx
			jnz @inner
			pop ecx
			pop eax
			mov BYTE PTR[ebx+eax],dl
			inc ebx
			dec ecx
			cmp ecx,0
		jnz @outer
	.endif
	Ret
Obfuscate EndP

EnableDlgItems PROC hWnd:DWORD
	sub esp,4
	mov DWORD PTR[ebp-4],1002
	@@:
		invoke GetDlgItem,hWnd,DWORD PTR[ebp-4]
		invoke EnableWindow,eax,1
		inc DWORD PTR[ebp-4]
		cmp DWORD PTR[ebp-4],1004
	jle @b
	invoke GetDlgItem,hWnd,IDC_UNLOCK
	invoke EnableWindow,eax,0
	invoke GetDlgItem,hWnd,IDC_UNLOCKKEY
	invoke EnableWindow,eax,0	
	Ret
EnableDlgItems EndP

end start 


