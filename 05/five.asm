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
include five.inc

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
		.if eax == IDC_UNLOCK
			invoke GetDlgItemText,hWnd,IDC_UNLOCKKEY,ADDR UnlockCode,SIZEOF UnlockCode+1
			.if eax>7
				invoke HashUnlockCode
				invoke Obfuscate,hWnd
				invoke EnableDlgItems,hWnd
				jmp @return
			.else
				invoke MessageBox,hWnd,ADDR UnlockCodeText,ADDR UnlockCodeTitle,MB_ICONWARNING
			.endif
		.elseif eax == IDC_CHECK
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
			invoke lstrlen,ADDR NameBuffer
			invoke Round1,eax
			invoke GetDlgItemText,DWORD PTR [EBP+8],IDC_SERIAL,ADDR EnteredSerialBuffer,SIZEOF EnteredSerialBuffer+1
			cmp eax,1
			jge comparestrings
			invoke MessageBox,NULL,ADDR SerialTooShort,ADDR Error,MB_OK
			jmp return
			comparestrings:
			invoke CompareStrings
			invoke SetDlgItemText,DWORD PTR [EBP+8],IDC_SERIAL,ADDR SerialBuffer
			return:
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

HashName PROC NameLen:DWORD
	mov esi,OFFSET NameBuffer
	mov ecx,NameLen
	@@:
		mov eax,ecx
		mul cl
		add al,ah
		mov bl,al
		mov al,BYTE PTR[esi]
		mul bl
		add al,ah
		add BYTE PTR[NameHash],al
		inc esi
		dec ecx
	jnz @b
	Ret
HashName EndP

Round1 PROC NameLen:DWORD
	LOCAL LowBit:BYTE
	mov NameHash,0
	invoke HashName,NameLen
	mov edi,OFFSET SerialBuffer
	mov ecx,SIZEOF SerialBuffer
	mov LowBit,0
	@@:
		mov al,NameHash
		add al,cl
		mul al
		add al,ah	
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
		dec ecx
	jnz @b
	Ret
Round1 EndP

@end:
nop
nop
nop
nop


CleanStrings PROC
	invoke RtlZeroMemory,ADDR EnteredSerialBuffer,SIZEOF EnteredSerialBuffer
	invoke RtlZeroMemory,ADDR NameBuffer,SIZEOF NameBuffer
	invoke RtlZeroMemory,ADDR SerialBuffer,SIZEOF SerialBuffer
	invoke RtlZeroMemory,ADDR UnlockCode,SIZEOF UnlockCode
	invoke RtlZeroMemory,ADDR UnlockHash,SIZEOF UnlockHash
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


HashUnlockCode PROC
	mov esi,OFFSET UnlockCode
	mov ecx,SIZEOF UnlockCode
	mov BYTE PTR[UnlockHash],0
	@@:
		mov eax,ecx
		mul cl
		add al,ah
		mov bl,al
		mov al,BYTE PTR[esi]
		mul bl
		add al,ah
		add BYTE PTR[UnlockHash],al
		inc esi
		dec ecx
	jnz @b
	Ret
HashUnlockCode EndP

Obfuscate PROC hWnd:DWORD
	sub esp,4
	invoke lstrlen,ADDR UnlockCode
	mov DWORD PTR[ebp-4],eax
	.if DWORD PTR[ebp-4]<=1
		invoke MessageBox,hWnd,ADDR UnlockCodeText,ADDR UnlockCodeTitle,MB_ICONEXCLAMATION
	.else
		mov eax,OFFSET @begin
		mov ecx,OFFSET @end-3
		sub ecx,eax
		xor ebx,ebx
		@outer:
			mov dl,BYTE PTR[ebx+eax]
			xor dl,UnlockHash
			mov BYTE PTR[ebx+eax],dl
			inc ebx
			dec ecx
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


