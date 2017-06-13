;Check code.asm

drawplayerone proc 
push bx
	;Player1
	DrawRect  x1p1, y1p1, 6, 6, 8
	mov bx,x1p1
	mov x1s1,bx
	add x1s1,6
	sub bx,bx			
	mov bx,y1p1
	mov y1s1,bx			
	add y1s1,2 
    ;Gun1
    DrawRect x1s1, y1s1, 2, 3, 8
pop bx
RET
drawplayerone endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
movmentforplayer1 proc
push dx
push cx
push bx
push ax
sub ax,ax 		

;The Check loop Checks if there is any Key Press
check:
	  
	  ;Change Time
	  dec timerSpeed
	  JNZ SkipTimeDec
		dec timerSpeed2
		cmp timerSpeed2, 0
		JNZ SkipTimeDec
			mov timerSpeed2, 3
			mov timerSpeed, 0FFFFh
			dec time
			call winandlose
			call displaytime

SkipTimeDec:	  
	  ;Check that it's time to move player1's shot
	  dec ShootTimer1
	  JNZ checkplayer2shoot
	  mov ShootTimer1, 00FFFh
	  call movexistingshots
	  call DrawVerticalLiness
	  
checkplayer2shoot:	
	  ;Check that it's time to move player2's shot
	  dec ShootTimer2
	  JNZ continueCheck
	  mov ShootTimer2, 00FFFh
	  call movexistingshots2
	  call DrawVerticalLiness
	
continueCheck:
	
	  ;Check for data received and excuted movement for player two if received anything
      call ReceiveData
	  
	  ;Check for key press
      mov ah,1
      int 16h
	  jz check
mov valuetosend,ah
	  call send
	  
	  ;Checks For Esc  (Exit)
	  cmp ah, 1h
	  JNE ContinueCheckingRight
	  call nomove			;To clear the buffer
	  mov GameMode, 1		;Main menu mode
	  pop ax	 
	  pop bx
	  pop cx
	  pop dx
	  ret 

ContinueCheckingRight:	  
      call right  
pop ax	 
pop bx
pop cx
pop dx
ret 
movmentforplayer1 endp 	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right proc
	cmp ah,4dh		;Scan code for right click
	je cop1			;cop = range check
	call left
	ret
cop1:				;range check
	mov bx, x1p1
	add bx, 16		;8 (width of player) + 8 (next movement)
	cmp bx, 106		;First Vertical Line
	JL obst1
	sub bx, bx
	ret
	
obst1:				;obstacles check
	mov bl,6
	mov cx, x1p1
	add cx, 16		;X coordinates
	mov dx, y1p1
checkloop1:	;-----------------------------------
	
	mov bh, 0		;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2		;Green Color for obstacle
	je endmove
	add dx,1	;Y coordinates
	dec bl
	jnz checkloop1
	jmp code1
	;-------------------------------------
endmove:
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code1:				;Code that prints and do the main function of movement
    DrawRect  x1p1, y1p1, 6, 6,0
    DrawRect  x1s1, y1s1, 2, 3,0 
	add x1p1,8
	add x1s1,8
    DrawRect  x1p1, y1p1, 6, 6, 8
    DrawRect  x1s1, y1s1, 2, 3, 8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bx,bx
	sub al, al
ret
right endp	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left proc
cmp ah,4bh			;Left scan code
	je cop2                                                                  
	call up
	ret
cop2:				;range check
	cmp x1p1,0		;Start of the game. Left most point of the window
	jne obst2
	ret
	
obst2:			;obstacles check
	mov bl,6
	mov cx, x1p1
	sub cx, 8		;X coordinates.  8(movement of the player. No need for another 8 as x1p1 is already the left top corner of player)
	mov dx, y1p1
	;-----------------------------------
checkloop2:
	add dx,1	;Y coordinates + 1 to check all the boundaries
	mov bh, 0		;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2		;Green Color for obstacles
	je endmove2
	dec bl
	jnz checkloop2
	jmp code2
	;-------------------------------------
endmove2:
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code2:				;Code that prints and do the main function of movement
    DrawRect  x1p1, y1p1, 6, 6,0
    DrawRect  x1s1, y1s1, 2, 3,0 
	sub x1p1,8
	sub x1s1,8
    DrawRect  x1p1, y1p1, 6, 6, 8
    DrawRect  x1s1, y1s1, 2, 3, 8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
ret
left endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

up proc
cmp ah,48h			;Up scan code
	je cop3
	call down
	ret
cop3:				;Range check
      
	cmp y1p1,12 	;Top most available point, 12 not 10 as y1p1 will be 12 in such case 
	jg obst3
	ret
	
obst3:				;obstacles check
	mov cx, x1p1
	add cx, 4		;X coordinates 	(4 to move to the centre of the width. Width of player is 8)
	mov dx, y1p1
	sub dx, 4		;Y coordinates	(Next movement will sub 4)  kanet 6 
	mov bh, 0		;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2		;Green color
	JNE code3
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code3:				;Code that prints and do the main function of movement
    DrawRect  x1p1, y1p1, 6, 6,0
    DrawRect  x1s1, y1s1, 2, 3,0 
	sub y1p1,4
	sub y1s1,4
    DrawRect  x1p1, y1p1, 6, 6,8
    DrawRect  x1s1, y1s1, 2, 3,8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
ret
up endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

down proc
cmp ah,50h				;Down scan code
	je cop4
	call PlayerShoot1
	ret
cop4:					;Range check
	cmp y1p1,151		;Down most point before the chat screen  151 not 153 as y1p1 will be 151 in such case
    jl obst4	
	ret 
	
obst4:					;obstacles check
	mov cx, x1p1
	add cx, 4			;X coordinates.  4 (To move to the centre of the width. Width of player is 8)
	mov dx, y1p1
	add dx, 10			;Y coordinates	 10 (Next movement is 6 + 4 for the player's length. Calculated from TOP left corner) kanet 12
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2			;Green Color
	JNE code4
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code4:					;Code that prints and do the main function of movement
    DrawRect  x1p1, y1p1, 6, 6,0
    DrawRect  x1s1, y1s1, 2, 3,0 
	add y1p1,4
	add y1s1,4
    DrawRect  x1p1, y1p1, 6, 6,8
    DrawRect  x1s1, y1s1, 2, 3,8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
ret
down endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PlayerShoot1 proc
	cmp ah,39h			;Scan code for space
	je ShootCode
	ret
ShootCode:

	mov cx ,3				;no of bullets per time (loop counter)
	mov si,0				;index for traversling through bulletarray (Shoot1X[si]) 
travshots:
	cmp Shoot1X[si], 400	;Checks that there isnt an existing shot. Can shoot one bullet at a time. 400 means there is no shot on the screen
	JE gunobst 				;found empty place to shoot
	add si, 2				;Cuz Shoot1X is a dw	
	loop travshots
	
	sub cx, cx
	sub dx, dx
	sub bx, bx
	sub ax, ax
	ret



gunobst:				;obstacles check
	mov cx, x1s1
	add cx, 8			;3 for gun and 5 for shots width 
	mov dx, y1s1
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2			;Green color code
	Jne initializeshot
	sub cx, cx
	sub dx, dx
	sub bx, bx
	sub ax, ax
	ret
	
initializeshot:			;Does the function of this code. Initializes bullet's coordinates + Draws the first bullet only.
	
	;mov x coordinates of gun to shoot
	mov bx, x1s1 
	mov Shoot1X[si], bx
	;mov y coordinates of gun to shoot
	mov bx, y1s1 
	mov Shoot1Y[si], bx
	;Fixing The X Coordinates By Adding.  Y coordinates does not need to be changed
	add Shoot1X[si], 4
	DrawRect  Shoot1X[si], Shoot1Y[si], 2, 5,5	
	
	sub cx, cx
	sub dx, dx
	sub bx, bx
	sub ax, ax	
ret
PlayerShoot1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movexistingshots proc
push cx
push si 
push ax 
	mov si,0
	mov cx ,3
travshotsexist:
	call moveShot1
	add si, 2 
	loop travshotsexist
	pop ax 
	pop si
	pop cx
	ret

movexistingshots endp


;;;;;

moveShot1 proc
push ax
push bx
push cx
push dx
	;Checks that there is an existing shot
	cmp Shoot1X[si], 400
	Jmp ContinueMoveShot1
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
ContinueMoveShot1:							;Erases the existing shot
	DrawRect Shoot1X[si], Shoot1Y[si], 2, 5,0	
	add Shoot1X[si], 5
	
	
mov bl, 5		;Loop's counter 5 times. Player cant react for 5 pixels. 5 is the width of the bullet. Checks that each Bullet's pixel will
				;not face any problems  (Range, Obstacle, Player)
BIGLOOPshot1:
	inc Shoot1X[si]								;1 pixel after end of the shot
	
	;Range Check
	cmp Shoot1X[si], 320
	JL ObstaclePlayerCheck1
	
	;Clears
	mov Shoot1X[si], 400
	mov Shoot1Y[si], 400
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
ObstaclePlayerCheck1:						;Checks for obstacles
	mov cx, Shoot1X[si]
	mov dx, Shoot1Y[si]
	mov bh, 0								;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2								;Checks if it is green
	Jne Playercheck1
	
	;Decreases the health of the Obstacle
	call DetectObstaclePlayer1Side
	
	;Clears
	mov Shoot1X[si], 400
	mov Shoot1Y[si], 400
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
Playercheck1:								;Checks there is no player
	cmp al, 8								;Grey Color code. Player's color
	JNE continueBIGLOOPshot1
	
	    call decearzehp2
		call winandlose            ;;============================Decrease health of Player2========;;	
	;clear
	mov Shoot1X[si], 400
	mov Shoot1Y[si], 400
	pop dx
	pop cx
	pop bx
	pop ax
	ret

continueBIGLOOPshot1:						;Decrement the loops'c counter (bl)
	dec bl
	JNZ BIGLOOPshot1						;The main loop (The 5 timed-loop)
	
	;Outside The BigLoop
	sub Shoot1X[si], 5							;To go to the top LEFT corner of the shot
	DrawRect  Shoot1X[si], Shoot1Y[si], 2, 5,5		;Draws the bullet
pop dx
pop cx
pop bx
pop ax
ret
moveShot1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Player1 Bullet hits from the left of the obstacle. Same X-axis as Obstacle's X-Coordinates
;Takes the Shoot1X[si] and compares it with the array of Obstacle X-Coordinates
DetectObstaclePlayer1Side proc
push di
push cx
push dx
	mov di, 0
	mov cx, 0
LoopThroughObstXCord1:	;Loop to find the Obstacle from the X-Coordinates array of Obstacles
	mov dx, Shoot1X[si]
	cmp dx, ObstXCord[di]
	JE ExitLoopObstXCord1
	
	add di, 2			;ObstXCord is dw. Need to add di, 2
	inc cx
	cmp cx, 6
	JNE LoopThroughObstXCord1
	
	;Exit loop from here means none of the obstacles fit this point. (Would rarely happen unless error occurs)
	pop dx
	pop cx	
	pop di
	ret
	
ExitLoopObstXCord1:
	mov di, cx			;Stores the index of the obstacle.
	dec ObstHealth[di]
	
	;Checks if it should delete the obstacle or not (Health=0 means delete)
	cmp ObstHealth[di], 0
	JNE	ExitObstFuncP1
	mov dx, di
	call EraseObstacle
	
ExitObstFuncP1:
pop dx
pop cx	
pop di
ret
DetectObstaclePlayer1Side endp

decearzehp2 proc  
push ax 
push bx 
sub ax,ax
sub bx,bx 
mov bx,312
mov ah,10
mov al,playertwohealth 
sub playertwohealth,1
mul ah
sub bx,ax 
mov playertwohealthsp,bx
DrawRect playertwohealthsp,0,9,8,0
pop bx 
pop ax
ret 
decearzehp2 endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReceiveData proc
push ax
push dx
	mov dx, 3FDH		;Line Status Register
	in al, dx			
	test al, 1			;checks if bit 0 (data ready) is = 1	
	jnz ReceivedDataTrue
	pop dx
	pop ax
	ret					;Will exit if no data received
ReceivedDataTrue:
	mov dx, 03F8H		;Receive Data Register
	in al, dx
	mov ValueToReceive, al
	call movmentforplayer2
	mov ValueToReceive,0H
pop dx
pop ax
ret
ReceiveData endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
send proc   
    push ax
    push bx
    push cx
    push dx
	sub ax,ax 
call adjusttosend
    regcheck:
    mov dx,3fdh ; line reg address
    in al,dx
    test al,00100000b
    jz regcheck;check the line reg is empty to send or not  
    mov dx,3f8h ; for data transfer
    mov al,valuetosend
    out dx,al
mov valuetosend,0H 	
    pop dx
    pop cx 
    pop bx
    pop ax
ret
send endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

adjusttosend proc 
cmp valuetosend ,4dh
je adjusttoleft
cmp valuetosend,4bh
je adjusttoright 
cmp valuetosend,48h
je adjusttoup
cmp valuetosend,50h
je adjusttodown
cmp valuetosend,39h
je adjustshoot
jmp exit 
adjusttoleft:
mov valuetosend,1eh
jmp exit
adjusttoright:
mov valuetosend,20h
jmp exit
adjusttoup:
mov valuetosend,11h
jmp exit 
adjusttodown:
mov valuetosend,1Fh
jmp exit
adjustshoot:
mov valuetosend,0Eh
exit :
ret 
adjusttosend endp