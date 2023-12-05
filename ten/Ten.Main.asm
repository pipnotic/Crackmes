.686
.model flat,stdcall
option casemap:none

include Ten.Vars.inc
include Ten.Func.asm

.code

DlgProc PROC hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM 
	.if uMsg == WM_INITDIALOG
		push hWnd
		pop hWindow
		invoke LoadIcon,hInstance,ICON
		invoke SendMessage,hWindow,WM_SETICON,1,eax
		invoke GetDlgItem,hWindow,IDC_HASH
		invoke SetFocus,eax 
	.elseif uMsg == WM_COMMAND
		mov	eax,wParam
		.if eax == IDC_DECRYPT_CODE
			
			; Read MD5 hash from input field
			invoke GetDlgItemText,hWindow,IDC_HASH,ADDR MD5Hash, LENGTHOF MD5Hash
			
			.if eax != 0				
				; Enable "GO" button
				invoke GetDlgItem,hWindow,IDC_RUN_CODE
				invoke EnableWindow,eax,1
				
				; Disable "Unlock" button
				invoke GetDlgItem,hWindow,IDC_DECRYPT_CODE
				invoke EnableWindow,eax,0
				
				; Create a DWORD hash of the MD5 entered by the user
				invoke HashMD5
				; Make sure the hashing succeeded
				.if eax != 0
					; Copy its value to our DWORD global
					mov Hash,eax
					; Use this value to decrypt the secret
					invoke XorSolutionStringFunction,eax
				.else
					; Things didn't work out as we had hoped, inform the user
					invoke MessageBox,hWindow,CTXT("Unable to create hash.."),CTXT(".=[ Error Creating DWORD Hash"),MB_OK
				.endif
			.else
				; The user entered nothing
				invoke MessageBox,hWindow,CTXT("Please enter your MD5 hash and try again"),CTXT(".=[ Error Reading MD5 Hash"),MB_OK
			.endif
		.elseif eax == IDC_RUN_CODE
		
			; Disable "GO" button
			invoke GetDlgItem,hWindow,IDC_RUN_CODE
			invoke EnableWindow,eax,0
			
			; Enable "Unlock" button
			invoke GetDlgItem,hWindow,IDC_DECRYPT_CODE
			invoke EnableWindow,eax,1
			
			call DisplayDecryptedKey
			
			; Check that we have crunched the MD5 into a DWORD
			mov eax,Hash
			.if eax != 0
				invoke XorSolutionStringFunction,eax
			.endif
			
		.elseif eax==IDC_ABOUT
			invoke MessageBox,hWindow,ADDR szAbout,CTXT("-=[ About"),MB_ICONINFORMATION
		.elseif eax==IDC_EXIT
			invoke SendMessage,hWindow,WM_CLOSE,0,0
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog,hWindow,0
	.endif
	
	@return:
	xor eax,eax
	ret 
DlgProc ENDP 


start:

; Set the exception handler
; MASM assumes the use of this register to be ERROR by default
assume fs:nothing
push  offset DisplayErrorAndExit
push  fs:[0]
mov  fs:[0], esp

;Generate an exception inside the guarded area to test it
; int 3
  
pop fs:[0]
add esp,4

invoke GetModuleHandle, NULL 
mov hInstance,eax

invoke DialogBoxParam,hInstance,IDD_CHALLENGE_TEN,0,ADDR DlgProc,0 
invoke ExitProcess,eax 


end start