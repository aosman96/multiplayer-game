;Check code

;Draws Line. Col is the column. Row is the row. VarHor indicates if it is a horizontal or vertical line. 1 = Vertical.
DrawLine macro col,row,VarHor
 Local  backHor
 Local	backVer
 Local  EndDrawLine 
push cx
push dx
push ax
push bx
pushF
 
	mov cx, col
	mov dx, row
	mov al, 7
	mov ah, 0ch
 
	;if it is 1, will draw Vertical Line
	mov bl,1
	cmp bl,VarHor
	JE  backVer
	
	;If it is anthing else but 0, will go out
	mov bl,0
	cmp bl,VarHor
	JNE EndDrawLine
 
backHor:		;Loop that draws horizontal line
	int 10h
	inc cx
	cmp cx, 320
	jnz backHor
	JMP EndDrawLine
 
backVer:		;Loop that draws vertical line
	int 10h
	inc dx
	cmp dx, 160
	jnz backVer

EndDrawLine:
popF 
pop bx
pop ax
pop dx
pop cx
endm DrawLine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Draws rectangle. X1,Y1 are coordinates. L is length. W is width. Color~~
DrawRect macro X1, Y1, L, W, color
Local	backRect
push cx
push dx
push ax
push bx
pushF
 
	mov cx, X1
	mov dx, Y1
	mov al, color
	mov ah, 0ch

backRect:			;Draws the rectancle
	int 10h
	inc cx
 
	mov bx, X1
	add bx, W
 
	cmp cx, bx
	JNE backRect
;Outside Loop1 
	inc dx
	mov cx, X1

	mov bx, Y1
	add bx, L
 
	cmp dx, bx
	JNE backRect
 
popF
pop bx
pop ax
pop dx
pop cx 
endm DrawRect