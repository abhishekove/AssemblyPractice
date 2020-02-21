%macro print 2
	mov rax,1
	mov rdi,2
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro
%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro exit 0
	mov rax,60
	mov rdi,00
syscall
%endmacro

section .data
msg1 db 10,"enter 1st number:",10
msg1_l equ $- msg1	
msg2 db 10,"enter 2nd number:",10
msg2_l equ $- msg2
msg3 db 10,"Final answer:",10
msg3_l equ $- msg3
msg4 db 10,"invalid choice",10
msg4_l equ $- msg4
	
menu db 10,"1.Successive Add",10
     db 10,"2.Add shift",10
     db 10,"3.Exit",10
     db 10,"enter your choice",10
menu_l equ $- menu     	
	
section .bss
	
	char_ans resb 5
	n1 resb 16
	n2 resb 16
	ans resw 1
	ansh resw 1
	ansl resw 1
     	char_ans_l equ $- char_ans
	buf resb 5

section .text
	global _start:
_start:
	
	MENU1 : print menu,menu_l
	        read buf,2
	        mov al,[buf]
	        
	   c1: cmp al,'1'
	       jne c2
	       call successive_addition
	       jmp MENU1

	   c2: cmp al,'2'
	       jne c3
	       call add_shift
	       jmp MENU1	       
	            
	   c3: cmp al,'3'
	       jne invalid
	   
    invalid: print msg4,msg4_l
	       jmp MENU1               
	exit
	


Accept_16:
	read buf,5
	mov rsi,buf
	mov rcx,4
	mov bx,0
	
next_byte:
	shl bx,4
	mov al,[rsi]
	
	cmp al,'0'
	jb error
	cmp al,'9'
	jbe sub30
	
	cmp al,'A'
	jb error
	cmp al,'F'
	jbe sub37
	
	cmp al,'a'
	jb error
	cmp al,'f'
	jbe sub57
	
	sub57:sub al,20h
	sub37:sub al,07h
	sub30:sub al,30h
	
	add bx,ax
	inc rsi
	dec rcx 
	jnz next_byte
ret
error:
	print msg3,msg3_l	
	exit
	
	
display_16:

	mov rbx,10
	mov rcx,4   ;2 for 2bit
	mov rsi,char_ans+3
	
cnt:
	mov rdx,0
	div rbx
	cmp dl,09h
	jbe add30
	add dl,07h
	
add30:
	add dl,30h
	mov [rsi],dl
	dec rsi
	dec rcx
	jnz cnt
	print char_ans,4
ret



add_shift:
	mov dword[ans],00
	
	print msg1,msg1_l
	call Accept_16
	mov [n1],bx
	
	print msg2,msg2_l
	call Accept_16
	mov [n2],bx
	
	xor ax,ax
	mov cx,16   ;display 4bit=8
	mov ax,[n1]
	mov bx,[n2]
	xor ebp,ebp
	
back: shl ebp,1
	shl ax,1
	jc next
	jmp next1


next: add ebp,ebx

next1: dec cx
	 jnz back	
	
	
final: mov [ans],ebp 
       print msg3,msg3_l
        
	  mov eax,[ans]
	  call display_16

  ret	  					


successive_addition:
	mov word[ansh],00
	mov word[ansl],00
	
	print msg1,msg1_l
	call Accept_16
	mov [n1],bx
	
	print msg2,msg2_l
	call Accept_16
	mov [n2],bx
	
	mov ax,[n1]
	mov cx,[n2]
	
	cmp cx,0
	je final

back1: add [ansl],ax
	jnc next2
	inc word[ansh]
	
next2: dec cx
	jnz back1
	
final1:  print msg3,msg3_l

	  mov ax,[ansh]
	  call display_16
	  
	  mov ax,[ansl]
	  call display_16
  ret	  					

	
