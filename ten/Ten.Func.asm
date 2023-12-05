.code


XorSolutionStringFunction PROC,hash:DWORD
	
	mov eax,OFFSET @SolutionStringStart
	mov ecx,OFFSET @SolutionStringEnd
	sub ecx,eax
	xor ebx,ebx
	@loop:
		mov edx,DWORD PTR DS:[EBX+EAX]
		xor edx,hash
		mov DWORD PTR DS:[EBX+EAX],EDX
		mov edx,hash
		ror edx,1
		mov hash,edx
		add ebx,4
		sub ecx,4
	jge SHORT @loop

	mov eax,pMem
	ret
XorSolutionStringFunction ENDP


HashMD5 PROC
	cld
	xor edi,edi
	mov esi,OFFSET MD5Hash
	mov ecx,LENGTHOF MD5Hash
	jmp @cond
		@while:
			lods byte ptr ds:[esi]
			add edi,eax
			ror edi,cl
			dec ecx
		@cond:
		test ecx,ecx
	jnz @while
	mov eax,edi
	
	@@:
	Ret
HashMD5 ENDP


DecoyDecryptionFunction PROC

	Ret
DecoyDecryptionFunction ENDP


@SolutionStringStart:

COMMENT !
Decrypted Bytes:

	DB 020h
	DB 020h
	DB 020h
	DB 053h
	DB 065h
	DB 063h
	DB 072h
	DB 065h
	DB 074h
	DB 03ah
	DB 020h
	DB 034h
	DB 064h 
	DB 037h 
	DB 066h 
	DB 032h 
	DB 061h 
	DB 064h 
	DB 036h 
	DB 063h 
	DB 037h 
	DB 035h 
	DB 032h 
	DB 038h 
	DB 034h 
	DB 065h 
	DB 039h 
	DB 031h 
	DB 062h 
	DB 036h 
	DB 039h 
	DB 033h 
	DB 032h 
	DB 065h 
	DB 033h 
	DB 063h 
	DB 062h 
	DB 063h 
	DB 038h 
	DB 030h 
	DB 030h 
	DB 065h 
	DB 033h
	DB 020h
	DB 020h
	DB 020h
	DB 020h
	DB 020h
	
!

; Encrypted Bytes:
DB 0C2h
DB 0C3h
DB 0D8h
DB 00Ah
DB 087h
DB 080h
DB 08Ah
DB 03Ch
DB 096h
DB 0D9h
DB 0D8h
DB 06Dh
DB 086h
DB 0D4h
DB 09Eh
DB 06Bh
DB 083h
DB 087h
DB 0CEh
DB 03Ah
DB 0D5h
DB 0D6h
DB 0CAh
DB 061h
DB 0D6h
DB 086h
DB 0C1h
DB 068h
DB 080h
DB 0D5h
DB 0C1h
DB 06Ah
DB 0D0h
DB 086h
DB 0CBh
DB 03Ah
DB 080h
DB 080h
DB 0C0h
DB 069h
DB 0D2h
DB 086h
DB 0CBh
DB 079h
DB 0C2h
DB 0C3h
DB 0D8h
DB 079h
@SolutionStringEnd:
DB 00h

DisplayDecryptedKey PROC
	Invoke MessageBox,hWindow,OFFSET @SolutionStringStart, CTXT("-=[ Solution Key: Look valid to you?"),MB_OK
	Ret
DisplayDecryptedKey endp

DisplayErrorAndExit PROC
	Invoke MessageBox,hWindow,CTXT("Sorry, you appear to have entered an invalid code..",0Dh,0Ah,"Exiting.. goodbye."), CTXT("-=[ Exception"),MB_ICONEXCLAMATION
	Invoke ExitProcess,NULL
	Ret
DisplayErrorAndExit ENDP

