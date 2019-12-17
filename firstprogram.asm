Section .data
          msg db 10,"Hello!!! This is my first program",10
          msg_len equ $-msg
          msg1 db 10,"Abhishek Ove",10
          msg_len1 equ $-msg1
          msg2 db 10,"Pimpri Chinchwad College of Engineering",10
          msg_len2 equ $-msg2

          %macro print 2
                           mov rax,1
                           mov rdi,1
                           mov rsi,%1
                           mov rdx,%2
                           syscall
            %endmacro
            %macro end 0
                    mov rax,60
                    mov rdi,00
                    syscall
             %endmacro
Section .text
          global _start
          _start:
                    print msg,msg_len
                    
                    print msg1,msg_len1
                    
                    print msg2,msg_len2
                    end
                    
                                        
                    
