;Check code.asm

playmode    PROC    
    ;change to video mode
    mov ah, 0
    mov al, 13h
    int 10h  
	
    ;Draw Horizontal Line
    DrawLine 0,9,0 
    DrawLine 0,160,0 
      
    call DrawVerticalLiness
	
    ;Player1
    call drawplayerone 
    ;Draw Obstacles Left
    DrawRect  ObstXCord[0], ObstYCord[0], 41, 15, 2
    DrawRect  ObstXCord[2], ObstYCord[2], 23, 15, 2
    DrawRect  ObstXCord[4], ObstYCord[4], 17, 22, 2
	;Health Bar Left Player1
	;Detecting the start of each bar is:   10(N-1) where N is the the Health of player. Ranges between 1-10
	DrawRect  90, 0, 9, 8, 9
	DrawRect  80, 0, 9, 8, 9
	DrawRect  70, 0, 9, 8, 9
	DrawRect  60, 0, 9, 8, 9
	DrawRect  50, 0, 9, 8, 9
	DrawRect  40, 0, 9, 8, 9
	DrawRect  30, 0, 9, 8, 9
	DrawRect  20, 0, 9, 8, 9
	DrawRect  10, 0, 9, 8, 9
	DrawRect  0, 0, 9, 8, 9
	
    ;Player2
    call drawplayertwo 
    ;Draw Obstacles Right
    DrawRect  ObstXCord[6], ObstYCord[6], 41, 15, 2
    DrawRect  ObstXCord[8], ObstYCord[8], 23, 15, 2
    DrawRect  ObstXCord[10], ObstYCord[10], 17, 22, 2
	;Health Bar Right Player2
	;312 - 10(N-1)  (N ranges from 1 to 10)
	DrawRect  222, 0, 9, 8, 9
	DrawRect  232, 0, 9, 8, 9
	DrawRect  242, 0, 9, 8, 9
	DrawRect  252, 0, 9, 8, 9
	DrawRect  262, 0, 9, 8, 9
	DrawRect  272, 0, 9, 8, 9
	DrawRect  282, 0, 9, 8, 9
	DrawRect  292, 0, 9, 8, 9
	DrawRect  302, 0, 9, 8, 9
	DrawRect  312, 0, 9, 8, 9

	call DisplayStatusBar
	
	;call nomove
	mov ah, 0
		
    ;MAIN GAME   
    game:
	   call movmentforplayer1
	   
	   ;Checks that gamemode isnt 1  (Main menu mode)
	   cmp GameMode, 1
	   JNE ContinueGameLoop
	   ret

ContinueGameLoop:  
;	   call movmentforplayer2	
	   
	   call nomove
	   
    JMP game 	   
ret
playmode    ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
nomove  proc
	mov ah, 0   ; get the key to clear the buffer
	int 16h
ret
nomove endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawVerticalLiness proc
	;Draw Vertical Line
	DrawLine 106,9,1
	DrawLine 213,9,1
ret
DrawVerticalLiness endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Compares the value in dl (Number of obstacle) to know which obstacle to erase
EraseObstacle proc
	cmp dl, 0
	JNE Eraseobst1
	DrawRect  ObstXCord[0], ObstYCord[0], 41, 15, 0
	ret

Eraseobst1:
	cmp dl, 1
	JNE Eraseobst2
	DrawRect  ObstXCord[2], ObstYCord[2], 23, 15, 0
	ret
	
Eraseobst2:
	cmp dl, 2
	JNE Eraseobst3
	DrawRect  ObstXCord[4], ObstYCord[4], 17, 22, 0
	ret
	
Eraseobst3:
	cmp dl, 3
	JNE Eraseobst4
	DrawRect  ObstXCord[6], ObstYCord[6], 28, 13, 0
	ret

Eraseobst4:
	cmp dl, 4
	JNE Eraseobst5
	DrawRect  ObstXCord[8], ObstYCord[8], 23, 14, 0
	ret
	
Eraseobst5:
	cmp dl, 5
	JNE ExitEraseObst
	DrawRect  ObstXCord[10], ObstYCord[10], 17, 14, 0
	ret
	
ExitEraseObst:	
ret	
EraseObstacle endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

changescreen proc 
mov ax,0000h
mov bh,0Eh
mov cx,0
mov dx,184fh
int 10h 
ret 
changescreen endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

readfp proc
mov ah, 0Ah
mov dx,offset pla1name 
int 21h    
ret
readfp endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readfp2 proc
mov ah,0AH
mov dx,offset pla2name
int 21h
ret
readfp2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displaywithcolour proc
push ax
push cx
push bx
push di
;--------------------------
	call movcursor     
    mov di,0 
disp:
	cmp gamename[di],'$'
	je return 
    mov ah,9
    mov bh,0
    mov al,gamename[di]
    mov cx,1h
    mov bl,000bh
	int 10h 
	
    inc di 
    add cursposx,1
    call movcursor
    jmp disp
	
return:
pop di 
pop bx
pop cx
pop ax
ret
displaywithcolour endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

displaywithcolour2 proc
push ax
push cx
push bx
push di 
	call movcursor     
    mov di,0 
	
disp2:
	cmp mes2[di],'$'
	je return2 
    mov ah,9
    mov bh,0
    mov al,mes2[di]
    mov cx,1h
    mov bl,00bh
    int 10h
	
    inc di 
    add cursposx,1
    call movcursor
    jmp disp2
	
return2:
pop di 
pop bx
pop cx
pop ax
ret
displaywithcolour2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
displaywithcolour3 proc
push ax
push cx
push bx
push di 
	call movcursor     
    mov di,0 
	
disp3:
	cmp mes3[di],'$'
	je return3 
    mov ah,9
    mov bh,0
    mov al,mes3[di]
    mov cx,1h
    mov bl,00bh
    int 10h 
	
    inc di 
    add cursposx,1
    call movcursor
    jmp disp3
	
return3: 
pop di 
pop bx
pop cx
pop ax
ret
displaywithcolour3 endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
displa proc
	mov ah,9
	mov dx,offset mes4
	int 21H
ret
displa endp  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

displayend proc 
	mov ah,9
	mov dx,offset mes5
	int 21h
ret
displayend endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movcursor proc 
push ax 
push dx
	mov bh,0
	mov ah,2 
	mov dl,cursposx 
	mov dh,cursposy 
	int 10h
pop dx
pop ax 
ret 
movcursor endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
winandlose proc
push bx
sub bx, bx


	mov cursposx,0AH
	mov cursposy,0Ah

	cmp GameMode, 1	;main menu
	JE 	BeforeMainMenu
	
	cmp time, 0
	JE BeforeMainMenu
	
	cmp playeronehealth,-1
	je player2w 
	cmp playertwohealth,-1
	je player1w
	;draw
	cmp time, 0
	JNE ExitTheWinLose
	mov bl, playertwohealth
	cmp playeronehealth, bl
	JE DRAWwins
	
ExitTheWinLose:	
	pop bx
	ret
;;;;;;;;
BeforeMainMenu:		;For game mode 1
	mov bl, playertwohealth
	cmp playeronehealth, bl
	JG player1w
	cmp playeronehealth, bl
	JL player2w
	cmp playeronehealth, bl
	JE DRAWwins
	
	
player2w:
	call changescreen
	call movcursor

	mov ah,9
	mov dx , offset pla2name+2
	int 21h
	mov cl,pla2name+1
	add cursposx,cl 
	call movcursor
	mov dx,offset win
	int 21h
	
	;For game mode 1
	cmp GameMode, 1
	JE DisplayScoreBoard
	JMP finalize
	
 player1w:
	call changescreen
	call movcursor
	mov ah,9
	mov dx , offset pla1name+2
	int 21h
	mov cl,pla1name+1
	add cursposx,cl 
	call movcursor
	mov dx,offset win
	int 21h
	
	;For game mode 1
	cmp GameMode, 1
	JE DisplayScoreBoard
	JMP finalize
	
 DRAWwins:
	call changescreen
	call movcursor
	mov ah, 9
	mov dx,offset drawname
	int 21h
	
	;For game mode 1
	cmp GameMode, 1
	JE DisplayScoreBoard
	JMP finalize
	
DisplayScoreBoard:	
	;Displays health incase of Game Mode 1
	call HealthScoreDisplay
	
	
	pop bx
	ret
	
finalize:
	mov ah,0
	int 16h
mov ah,4ch
int 21h
winandlose endp 
;;;;;;;;;;;;;;;;;;;;;;;;

HealthScoreDisplay proc
;Player1:
	add cursposy, 2
	mov cursposx, 0
	call movcursor
	;Player1 Name
	mov ah,9
	mov dx , offset pla1name+2
	int 21h
	;Prints Player1 Health
	add cursposy, 1
	mov cursposx, 0
	mov bl, playeronehealth
	mov HealthPrint, Bl
	inc HealthPrint
	call Healthtoasci
	call displayHealth
	
	;Player2:
	add cursposy, 2
	mov cursposx, 0
	call movcursor
	;Player2 Name
	mov ah,9
	mov dx , offset pla2name+2
	int 21h
	;Prints Player2 Health
	add cursposy, 1
	mov cursposx, 0
	mov bl, playertwohealth
	mov HealthPrint, Bl
	inc HealthPrint
	call Healthtoasci
	call displayHealth
ret
HealthScoreDisplay endp
;;;;;;;;;;;;;;;;;;;;;;;;

changetoasci proc 
 push ax 
 push bx
 push si 
 push cx 
   sub ax ,ax
 mov al,time 
  mov si,2
  mov cx ,3
  mov bl,10
 getasci:
 div bl 
 add ah,30h 
 mov tiasasci[si],ah
 dec si 
 sub ah,ah
 loop getasci 
 pop cx
 pop si
 pop bx
 pop ax
 ret
 changetoasci endp
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
displaytime  proc
push  ax
push bx 
push es 
push dx 
push cx
call changetoasci
mov ax,@data
mov es,ax 
sub ax,ax  
MOV BP, OFFSET tiasasci ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 0H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 7 ;white
MOV CX, 3 ; LENGTH OF THE STRING
MOV DH, 0;ROW TO PLACE STRING
MOV DL, 18 ; COLUMN TO PLACE STRING
;mov dx ,00AAh
INT 10H
pop CX
pop dx
pop es
pop bx
pop ax
ret
displaytime  endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

Healthtoasci proc 
 push ax 
 push bx
 push si 
 push cx 
   sub ax ,ax
 mov al,HealthPrint 
  mov si,1   ;;;;;;
  mov cx ,2
  mov bl,10
 GetHealthasci:
 div bl 
 add ah,30h 
 mov HealthAsci[si],ah
 dec si 
 sub ah,ah
 loop GetHealthasci 
 pop cx
 pop si
 pop bx
 pop ax
 ret
Healthtoasci endp
;;;;;;;;;;;;;;;;;;;;

displayHealth proc
push  ax
push bx 
push es 
push dx 
push cx
call Healthtoasci
mov ax,@data
mov es,ax 
sub ax,ax  
MOV BP, OFFSET HealthAsci ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 0H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 7 ;white
MOV CX, 2 ; LENGTH OF THE STRING
MOV DH, cursposy;ROW TO PLACE STRING
MOV DL, cursposx ; COLUMN TO PLACE STRING
;mov dx ,00AAh
INT 10H
pop CX
pop dx
pop es
pop bx
pop ax
ret
displayHealth endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;

DisplayStatusBar  proc
push  ax
push bx 
push es 
push dx 
push cx

mov ax,@data
mov es,ax 
sub ax,ax  
MOV BP, OFFSET mes6 ; ES: BP POINTS TO THE TEXT
MOV AH, 13H ; WRITE THE STRING
MOV AL, 0H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
XOR BH,BH ; VIDEO PAGE = 0
MOV BL, 7 ;white
MOV CX, 30 ; LENGTH OF THE STRING
MOV DH, 24;ROW TO PLACE STRING
MOV DL, 0 ; COLUMN TO PLACE STRING
;mov dx ,00AAh
INT 10H
pop CX
pop dx
pop es
pop bx
pop ax
ret
DisplayStatusBar  endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ExchangePlayerNames proc

	mov cx, 28
	mov si, 2
LoopExchangePlayer:
	;Send player1 name letter
	mov bl, pla1name[si]
	mov valuetosend, bl;			;# is a sign signal to tell player2 that he finished entering his name. Doesnt matter what to send
	LoopExchangePlayerValue:
    mov dx,3fdh 					;Line status register
    in al,dx
    test al,00100000b 				;Transmitter holding register (1 if empty, can send)         
    jz LoopExchangePlayerValue   	
    mov dx,3f8h 					;Transmit data Register
    mov al,valuetosend
    out dx,al
	
	;Receive Player2 name letter
RecevingLoopExchange:
	mov dx, 3FDH		;Line Status Register
	in al, dx			
	test al, 1			;checks if bit 0 (data ready) is = 1	
	jz RecevingLoopExchange
	
	mov dx, 03F8H		;Receive Data Register
	in al, dx
	mov pla2name[si], al

	;End loop
	inc si
	loop LoopExchangePlayer

ret
ExchangePlayerNames endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckPlayer2Done proc
	;Send that you have finished
	mov valuetosend, "#";			;# is a sign signal to tell player2 that he finished entering his name. Doesnt matter what to send
	Checkplayer2doneValue:
    mov dx,3fdh 					;Line status register
    in al,dx
    test al,00100000b 				;Transmitter holding register (1 if empty, can send)         
    jz Checkplayer2doneValue   	
    mov dx,3f8h 					;Transmit data Register
    mov al,valuetosend
    out dx,al
	
	call WaitingForPlayer2Screen
	
	;Check if player 2 finished or not
RecevingCheckPlayer2Done:
	mov dx, 3FDH		;Line Status Register
	in al, dx			
	test al, 1			;checks if bit 0 (data ready) is = 1	
	jz RecevingCheckPlayer2Done
	
	mov dx, 03F8H		;Receive Data Register
	in al, dx
	mov ValueToReceive, al
	
	cmp al, "#"
	jne RecevingCheckPlayer2Done
ret
CheckPlayer2Done endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitingForPlayer2Screen proc
	mov ax,0600h
	mov bh,0Ah
	mov cx,0
	mov dx,184fh
	int 10h 

	mov cursposx, 10
	mov cursposy, 10
	call movcursor
	
	mov ah,9
	mov dx,offset mes3
	int 21H
ret
WaitingForPlayer2Screen endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SendOperation proc
	SendOperationValue:
    mov dx,3fdh 					;Line status register
    in al,dx
    test al,00100000b 				;Transmitter holding register (1 if empty, can send)         
    jz SendOperationValue   	
    mov dx,3f8h 					;Transmit data Register
    mov al,valuetosend
    out dx,al
ret
SendOperation endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StatusBarInvitation proc
	;Status Bar notifying for invitation  MUST CHANGE************************************************************************************************
	call movcursor 
	mov ah, 9
	mov dx,offset drawname
	int 21h
ret
StatusBarInvitation endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InvitationAnswerCheck proc
InvitationAnswerLoop:
	mov ah, 0
	int 16h
	
	cmp al, 'n'			;Checks if the the press is "N". Rejects the invitation
	jne ContinueInvitationAnswerLoop
	mov valuetosend, 'n'
	call SendOperation
	mov GameMode, 1			;To return to main menu
	ret
ContinueInvitationAnswerLoop:	
	cmp al, 'y'
	jne InvitationAnswerLoop
	mov valuetosend, 'y'
	call SendOperation
	mov GameMode,0
ret
InvitationAnswerCheck endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
testprint proc
	mov ah, 2
	mov dl, 'A'
	int 21h
ret
testprint endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MainMenueCheck proc
push ax
push dx
push cx
sub ax,ax 
checkstart:
	cmp al,032h			;2 - starts game
	je SendPressMainMenue
	
	cmp al,01Bh			;Esc - Exit game
	jne ContinueCheckstart1
	mov GameMode, 2
	mov valuetosend, 01Bh
	call SendOperation
	pop cx
	pop dx
	pop ax
	ret
	
	ContinueCheckstart1:
	;Receive Letter to check if player2 sent an invitation
	mov dx, 3FDH		;Line Status Register
	in al, dx			
	test al, 1			;checks if bit 0 (data ready) is = 1	
	jz Continuecheckstart
	
;This part will only be accessed if received an invittion by player2~~~~~~~~~~~~~~~~
	;If received a signal that player2 sent something: (Probably started the game. Invitation to start)
	mov dx, 03F8H		;Receive Data Register
	in al, dx
	mov ValueToReceive, al	
	;Check if the ValueToReceive is "2", means player2 started the game
	cmp ValueToReceive, "2"
	jne Continuecheckstart		;Means that player2 didnt start the game. No inv will be received
	
	call StatusBarInvitation
	mov Host, 1					;Assigning this player as a client
	;Loop that waits for player answer for the invitation. Yes or No.
	call InvitationAnswerCheck
	pop cx
	pop dx
	pop ax
	ret
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Continuecheckstart:	

	mov ah,1
    int 16h
	jmp checkstart				;End of loop

SendPressMainMenue:	
	;Outside the loop. Used to send they pressd key
	;Sends invitiation to player2. Tells player 2 that he started
	mov valuetosend, "2"			;"2" is a sign signal to tell player2 that I started the game
	call SendOperation
	
	call WaitingForPlayer2Screen
	
	CheckInvitationAnswerLoop:
	mov dx, 3FDH		;Line Status Register
	in al, dx			
	test al, 1			;checks if bit 0 (data ready) is = 1	
	jz CheckInvitationAnswerLoop
	mov dx, 03F8H		;Receive Data Register
	in al, dx
	mov ValueToReceive, al
	
	;Checks the Answer of the Invitation
	cmp ValueToReceive, "n"		;Scan code for N  (No - invitation)
	jne ExitMainMenueCheck
	mov GameMode, 1
	pop cx
	pop dx
	pop ax
	ret
	
	ExitMainMenueCheck:
	mov GameMode, 0
pop cx
pop dx
pop ax
ret
MainMenueCheck endp