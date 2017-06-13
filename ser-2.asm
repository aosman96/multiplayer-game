.model small    
.data   
topscreenrow db 0
topscreencol db 0
lowerscreenrow db 13
lowerscreencol db 0 
lettertosend db ?
lettertoreceive db ?

.stack 64
.code
main proc far 
mov ax , @data
mov ds , ax 

call screeninitialization
call initialization 

loopmain:

checkpress:
    mov ah,01
    int 16h      ; zf =1 if there is a key pressed
    jz checkreceived
    mov ah,0     ; gets asci in al
    int 16h 
    mov lettertosend,al
    call writeontop
    call send 
    
checkreceived:
    mov dx,3fdh
    in al,dx
    test al,1  ; to check dataready bit to see if there is data ready to be received    
    jz checkpress
    mov dx , 03f8h 
    in al,dx
    cmp al,1Bh
    je exit 
    mov lettertoreceive , al 
    call writeonbelow

jmp loopmain
   
exit: 
    mov ah,4ch
    int 21h
main endp   
     
send proc   
    push ax
    push bx
    push cx
    push dx
    value:
    mov dx,3fdh ; line reg address
    in al,dx
    test al,00100000b
    jz value   ; to check if port received the data or not 
    mov dx,3f8h ; for data transfer
    mov al,lettertosend
    out dx,al
    cmp al,1Bh   ; check esc  we send it also to end the other program
    je exit 
    pop dx
    pop cx 
    pop bx
    pop ax
ret
send endp 

screeninitialization proc 
    
mov ah,00
mov al,03 
int 10h 

mov ah,02h
mov bh,00
mov dh,12   ; ROW 
mov dl,00   ;COLUMN
int 10h

mov ah,09  
mov bh,00
mov al,'-'
mov cx,50h ; NO. OF ITERATION
mov bl,5h  ; COLOR
int 10h   

 
ret
screeninitialization endp

initialization proc
     
mov dx , 3fbh       ;line control reg
mov al ,10000000b
out dx,al 
mov al,0ch
mov dx,3f8h      ; port fit with the data reg
out dx,al
mov al,00h
mov dx,3f9h  ;int controll reg 
out dx,al
mov al,00011011b
mov dx,3fbh
out dx,al   

RET
initialization ENDP

writeontop proc
    push ax
    push bx
    push cx 
    push dx

    mov ah , 02 
    mov dh , topscreenrow     ;row
    mov dl , topscreencol     ;columns
    mov bh ,00h
    int 10h
                       
write1:
    cmp lettertosend,0Dh ; CHECK ENTER 
    je adjustrowandcoltop   
    mov ah,09  
    mov bh,00
    mov al,lettertosend    ; asci 
    mov cx,1h ; NO. OF ITERATION
    mov bl,0Fh  ; COLOR
    int 10h
    
    add topscreencol,1
    cmp topscreencol,80        ;check if i reached the end of the line
    jae adjustrowandcoltop
    jmp popp  
    
adjustrowandcoltop: 
    mov topscreencol,0
    cmp topscreenrow,11   ; check if i reached the end of the first screen
    jae scrollup 
    add topscreenrow,1
    jmp popp 
    
scrollup:   
    ;sub topscreenrow,1   ; to return it to row 11 to not write on the dashes 
    mov ah,06h
    mov al,1h    ; scroll by 1 line
    mov bh,7h
    mov ch,0      ; upeer left row
    mov cl,0       ;upper left column
    mov dh,11       ; lower right row
    mov dl,79      ;lower right column
    int 10h


popp:    
    pop dx
    pop cx
    pop bx
    pop ax

ret
writeontop endp   

writeonbelow proc
    push ax
    push bx
    push cx
    push dx  
    
    mov ah, 02
    mov dh, lowerscreenrow
    mov dl, lowerscreencol
    mov bh,00h
    int 10h
    
write2:
    cmp lettertoreceive,0Dh ; CHECK ENTER 
    je adjustrowandcolbelow                 
    mov ah,09
    mov bh,00
    mov al,lettertoreceive
    mov cx,1h
    mov bl,0Fh
    int 10h   
    
    
    add lowerscreencol,1
    cmp lowerscreencol,80
    jae adjustrowandcolbelow
    jmp popp2 
adjustrowandcolbelow:
    mov lowerscreencol,0
    cmp lowerscreenrow,24   ; check if i reached the end of the second screen 
    jae scrollup2 
    add lowerscreenrow,1
    jmp popp2 
    
scrollup2:  
    ;sub lowerscreenrow,1 ; to keep writing on the screen and not surpass screen's limit 
    mov ah,06h
    mov al,1h    ; scroll by 1 line
    mov bh,7h
    mov ch,13     ; upeer left row
    mov cl,0     ;upper left column
    mov dh,25    ; lower right row
    mov dl,79    ;lower right column
    int 10h     
    
popp2:
    pop dx
    pop cx
    pop bx
    pop ax
ret
writeonbelow endp

end main