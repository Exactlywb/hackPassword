.model tiny

.code

org 100h

Start:
		call Greetings
		call EnterPassword
		
		cmp ax, 1
		
		je  CorrectPass
		jmp WrongPass

		jmp Exit

EnterPassword	proc
		
		mov dx, offset showMeUrPass
		call PrintPhrase

		call Scanner
		call Checker

		ret
		
		endp

Scanner         proc

                xor cx, cx

		lea bx, passBuf
		mov ah, 1h

TillNotEndScanning:
		int 21h

		cmp al, 0dh					; enter scan code
		je EndScanning

		cmp cx, maxPassLength
		je WrongPass

		mov [bx], al
		
		inc bx
		inc cx              

		jmp TillNotEndScanning

EndScanning:	
		ret
		endp

Checker		proc

		lea si, password
		lea di, passBuf

		cmp cx, passwordLength
		jne WrongPass

		dec cx

Comparator:
		mov bx, [si]
		mov ax, [di]
	
		cmp bx, ax
		jne WrongPass

		inc si
		inc di

		loop Comparator

		mov ax, 1

		ret
		endp

;----------------------------------------------------------
;Here we call print with our welcome phrase
;
;Destr:	dx, ah
;
;Entry: none
;
;Ret: none
;----------------------------------------------------------
Greetings	proc

		mov dx, offset welcomePhrase
		call PrintPhrase			
		
		ret
		endp
;----------------------------------------------------------
;Here we print our string
;
;Entry:	dx
;
;Destr: ah
;
;Ret: none
;----------------------------------------------------------	
PrintPhrase	proc

		mov ah, 09h
		int 21h

		ret

		endp

WrongPass:
		mov dx, offset wrongPasswordPhrase
		call PrintPhrase

		jmp Exit	

CorrectPass:
		mov dx, offset correctPasswordPhrase
		call PrintPhrase
		
		jmp Exit

;-----------------------------------------------------------
;Exit from the program		
;-----------------------------------------------------------
Exit:
		mov ax, 4c00h
		int 21h	

.data
		welcomePhrase		db	'Welcome to the club, buddy', 0dh, 10, '$'
		showMeUrPass		db	'Show me your big password', 0dh, 10, '$'
	
		wrongPasswordPhrase	db	0dh, 10,'Your password is wrong!', 0dh, '$'
		correctPasswordPhrase	db	'Congratulations! Your password is correct!', 0dh, '$'
	
		password		db	'Ded na drone'
		passwordLength		=	$ - password
	
		maxPassLength		=	30
		passBuf			db	maxPassLength	dup (0)

end Start

