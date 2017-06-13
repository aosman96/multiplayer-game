;Check code.asm

drawplayertwo proc
push bx
	;Player
	DrawRect  x1p2, y1p2, 6, 6, 8
	mov bx,x1p2
	mov x1s2,bx
	sub x1s2,3
	sub bx,bx
	mov bx,y1p2
	mov y1s2,bx
	add y1s2,2 
    ;Gun
    DrawRect x1s2, y1s2, 2, 3, 8
pop bx
ret
drawplayertwo endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movmentforplayer2 proc
push bx
push ax
	sub ax,ax 		

;	  mov ah,1
;      int 16h
cmp ValueToReceive,01h
jne continuetothenext
mov GameMode,1
continuetothenext:
      call left2
	  
pop ax	 
pop bx
ret 
movmentforplayer2 endp 	 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

left2 proc
	cmp ValueToReceive,20h
	je cop12
	call right2
	ret
cop12:					;range check
	mov bx, x1p2
	add bx, 8
	cmp bx, 319
	JL obst12
	sub bx, bx
	ret
	
	
	
obst12:					;obstacles check
	mov bl,6
	mov cx, x1p2
	add cx, 14			;X coordinates   ;6+8  cuz starts from x1p2 !
	mov dx, y1p2
checkloop12:	
	;-----------------------------------
	mov bh, 0		;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2		;Green Color for obstacle
	je endmove3
	add dx,1	;Y coordinates
	dec bl
	jnz checkloop12
	jmp code12
	;-------------------------------------
	
endmove3:
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code12:					;Does the functonality of the movement
    DrawRect  x1p2, y1p2, 6, 6,0
    DrawRect  x1s2, y1s2, 2, 3,0 
	add x1p2,8
	add x1s2,8
    DrawRect  x1p2, y1p2, 6, 6, 8
    DrawRect  x1s2, y1s2, 2, 3, 8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bx, bx
	sub al, al
ret
left2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right2 proc
	cmp ValueToReceive,1eh
	je cop22                                                                  
	call up2
	ret
cop22:					;Range check
	mov bx, x1p2
	sub bx, 8
	cmp bx, 213
	JG obst22
	sub bx, bx
	ret
	
obst22:					;obstacles check
	mov bl,6
	mov cx, x1p2
	sub cx, 8			;X coordinates
	mov dx, y1p2
	checkloop22:	
	;-----------------------------------
	mov bh, 0		;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2		;Green Color for obstacle
	je endmove4
	add dx,1	;Y coordinates
	dec bl
	jnz checkloop22
	jmp code22
	;-------------------------------------
	
endmove4:
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code22:					;Range Check
	cmp x1p2,0
	jne code32
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bx, bx
	sub al, al
	ret
	
code32:					;Does the main functionality of the movement
	DrawRect  x1p2, y1p2, 6, 6,0
    DrawRect  x1s2, y1s2, 2, 3,0 
	sub x1p2,8
	sub x1s2,8
    DrawRect  x1p2, y1p2, 6, 6, 8
    DrawRect  x1s2, y1s2, 2, 3, 8
ret
right2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

up2 proc
	cmp ValueToReceive,11h
	je cop32
	call down2
	ret
cop32:					;Range check
	cmp y1p2, 12
	JG obst32
	ret
	
obst32:					;obstacles check
	mov cx, x1p2
	add cx, 4			;X coordinates
	mov dx, y1p2
	sub dx, 4			;Y coordinates
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2
	JNE code42
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code42:					;Does the main functionality of the movement
    DrawRect  x1p2, y1p2, 6, 6,0
    DrawRect  x1s2, y1s2, 2, 3,0 
	sub y1p2,4
	sub y1s2,4
    DrawRect  x1p2, y1p2, 6, 6,8
    DrawRect  x1s2, y1s2, 2, 3,8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
ret
up2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

down2 proc
	cmp ValueToReceive,1Fh
	je cop42
	call PlayerShoot2
	ret
cop42:					;Range check
	mov bx, y1p2
	cmp bx,151     ; compare with 151 to check lower limit as y1p2 is 151 in such case 
	JL obst42
	sub bx, bx
	ret
	
obst42:					;obstacles check
	mov cx, x1p2
	add cx, 4			;X coordinates
	mov dx, y1p2
	add dx, 10			;Y coordinates
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2
	JNE code52
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub bh, bh
	sub al, al
	ret
	
code52:					;Does the main functionality of the movement
    DrawRect  x1p2, y1p2, 6, 6,0
    DrawRect  x1s2, y1s2, 2, 3,0 
	add y1p2,4
	add y1s2,4
    DrawRect  x1p2, y1p2, 6, 6,8
    DrawRect  x1s2, y1s2, 2, 3,8
	sub cx, cx
	sub dx, dx
	sub ah, ah
	sub al, al
	sub bx, bx
ret
down2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayerShoot2 proc
	cmp ValueToReceive,0Eh  		;backspace scan code
	je ShootCode2
	ret
	
ShootCode2:
	
	mov cx ,3				;no of bullets per time (loop counter)
	mov si,0				;index for traversling through bulletarray (Shoot1X[si]) 
travshots2:
	cmp Shoot2X[si], 400	;Checks that there isnt an existing shot. Can shoot one bullet at a time. 400 means there is no shot on the screen
	JE gunobst2 				;found empty place to shoot
	add si, 2				;Cuz Shoot1X is a dw	
	loop travshots2
	
	sub cx, cx
	sub dx, dx
	sub bx, bx
	sub ax, ax
	ret

gunobst2:				;obstacles check
	mov cx, x1s2
	sub cx, 5			;dont need to add as the x1s2 is the left point in the gun  so i will sub 5 which is the length of the shot
	mov dx, y1s2
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2
	Jne initializeshot2
	sub cx, cx
	sub dx, dx
	sub bx, bx
	sub ax, ax
	ret
	
initializeshot2:	
	;mov x coordinates of gun to shoot
	mov bx, x1s2 
	mov Shoot2X[si], bx
	;mov y coordinates of gun to shoot
	mov bx, y1s2 
	mov Shoot2Y[si], bx
	;Fixins the X coordinates
	sub Shoot2X[si], 6  	;5 is the length of the shot and extra 1 to avoid being stuck to the gun
	DrawRect  Shoot2X[si], Shoot2Y[si], 2, 5,5	
	sub cx, cx
	sub dx, dx
	sub bx, bx
	sub ax, ax
ret
PlayerShoot2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movexistingshots2 proc
push cx
push si 
push ax 
	mov si,0
	mov cx ,3
travshotsexist2:
	call moveShot2
	add si, 2 
	loop travshotsexist2
	pop ax 
	pop si
	pop cx
	ret

movexistingshots2 endp

;;;;;;;;;;

moveShot2 proc
push ax
push bx
push cx
push dx	
	;Checks that there is an existing shot
	cmp Shoot2X[si], 400
	JNE ContinueMoveShot2
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
ContinueMoveShot2:		;Erases the drawn bullet
	DrawRect Shoot2X[si], Shoot2Y[si], 2, 5,0						

mov bl, 5				;Loop for 5 times. Player cant react for 5 pixels. Width of the bullet		
BIGLOOPshot2:
	dec Shoot2X[si]			;1 pixel before end of the shot
	
	;Range Check
	cmp Shoot2X[si], 0
	JG ObstaclePlayerCheck2
	;Clears
	mov Shoot2X[si], 400
	mov Shoot2Y[si], 400
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
ObstaclePlayerCheck2:	;Obstacle Check
	
	;obstacles check
	mov cx, Shoot2X[si]
	mov dx, Shoot2Y[si]
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2			;Checks if it is green
	Jne Playercheck2	
	
	;Decreases the health of the Obstacle
	call DetectObstaclePlayer2Side
	
	;Clears	
	mov Shoot2X[si], 400
	mov Shoot2Y[si], 400
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
Playercheck2:			;Player's Check
	cmp al, 8
	JNE continueBIGLOOPshot2
	call decearzehp1
	call winandlose             ;;============================Decrease health of Player1========;;
	;clear
	mov Shoot2X[si], 400
	mov Shoot2Y[si], 400
	pop dx
	pop cx
	pop bx
	pop ax
	ret

continueBIGLOOPshot2:	;Decrements the bl (loop counter)
	dec bl
	JNZ BIGLOOPshot2
	
;Outside the BigLoop. Draws the bullet
	DrawRect Shoot2X[si], Shoot2Y[si], 2, 5,5
	
pop dx
pop cx
pop bx
pop ax
ret
moveShot2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Player2 Bullet hits from the right of the obstacle. Different X-axis as Obstacle's X-Coordinates
;Takes the Shoot2X[si] and compares it with the array of Obstacle X-Coordinates
DetectObstaclePlayer2Side proc
push di
push cx
push dx
	;The Bullet hits from the right, But the X-coordinates of the obstacle is at the top LEFT. Thus, need to subtract to get to the
	;LEFT corner of the Obstacle
	mov cx, Shoot2X[si]
	mov dx, Shoot2Y[si]
GetLeftCornerOfObstacle:
	dec cx
	mov bh, 0			;page number
	mov ah, 0Dh
	int 10h
	cmp al, 2			;Checks if it is green
	JE GetLeftCornerOfObstacle	
	
	mov Shoot2X[si], cx
	inc Shoot2X[si]			;Increment, as the Shoot2X[si] is now 1 pixel to the left of the Green Obstacle. Incremeting will make it
						;stand on the left most point of the obstacle
	
	mov di, 0
	mov cx, 0
LoopThroughObstXCord2:	;Loop to find the Obstacle from the X-Coordinates array of Obstacles
	mov dx, Shoot2X[si]
	cmp dx, ObstXCord[di]
	JE ExitLoopObstXCord2
	
	add di, 2			;ObstXCord is dw. Need to add di, 2
	inc cx
	cmp cx, 6
	JNE LoopThroughObstXCord2
	
	;Exit loop from here means none of the obstacles fit this point. (Would rarely happen unless error occurs)
	pop dx
	pop cx	
	pop di
	ret
	
ExitLoopObstXCord2:
	mov di, cx			;Stores the index of the obstacle.
	dec ObstHealth[di]
	
	;Checks if it should delete the obstacle or not (Health=0 means delete)
	cmp ObstHealth[di], 0
	JNE	ExitObstFuncP2
	mov dx, di
	call EraseObstacle
	
ExitObstFuncP2:
pop dx
pop cx	
pop di
ret
DetectObstaclePlayer2Side endp
decearzehp1 proc  
push ax 
sub ax,ax
mov ah,10
mov al,playeronehealth 
sub playeronehealth,1
mul ah 
mov playeronehealthsp,ax
DrawRect playeronehealthsp,0,9,8,0
pop ax
ret 
decearzehp1 endp 