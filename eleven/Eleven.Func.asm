.code


XorSecretString PROC
	mov eax, OFFSET szSecret
	mov esi,OFFSET HashTable
	mov ecx,lSecret
	xor ebx,ebx
	xor edi,edi
	@loop:
		mov edx,DWORD PTR DS:[ebx+eax]
		xor edx,DWORD PTR DS:[esi+edi]
		mov DWORD PTR DS:[ebx+eax],edx
		add ebx,4
		sub ecx,4
		add edi,4
		cmp edi,lHashTableLen
		jnz @f
			xor edi,edi
		@@:
		cmp ecx,1
	jg SHORT @loop
	ret
XorSecretString ENDP

Shuffle PROC
	mov eax, OFFSET szSecret
	xor ebx,ebx
	mov ecx,lSecret-2
	xor edx,edx
	mov dh,BYTE PTR DS:[eax+ecx]
	@loop:
	
		.if ecx == 0
			mov dl,BYTE PTR DS:[eax]
			xor dl,dh
		.else
			mov dl,BYTE PTR DS:[eax+ecx]
			xor dl,BYTE PTR DS:[eax+ecx-1]
		.endif
		
		mov BYTE PTR DS:[eax+ecx],dl
		dec ecx
		or ecx,ecx
	jge @loop
	Ret
Shuffle ENDP

InitialiseHashTable PROC,hash:DWORD
	mov esi,OFFSET HashTable
	mov ecx,TYPE HashTable
	mov edx,hash
	@@:
		ror edx,1
		mov DWORD PTR[esi+ecx-4],edx
		sub ecx,4
	jne @b
	Ret
InitialiseHashTable ENDP

HashMD5 PROC
	cld
	xor edi,edi
	mov esi,OFFSET MD5Hash
	mov ecx,LENGTHOF MD5Hash
	jmp @cond
		@while:
			lods byte PTR DS:[esi]
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


DisplayErrorAndExit PROC
	Invoke MessageBox,hWindow,CTXT("Sorry, you appear to have entered an invalid code..",0Dh,0Ah,"Exiting.. goodbye."), CTXT("-=[ Exception"),MB_ICONEXCLAMATION
	Invoke ExitProcess,NULL
	Ret
DisplayErrorAndExit ENDP

