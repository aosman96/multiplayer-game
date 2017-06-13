;Pixel Shooter
;Ahmed Mohamed Ismail Ahmed Amer		1142374
;Ahmed Osman Mohamed					1148161
;Ahmed Mahmoud Saied Soliman			1142334
;;
;	instructions	for player1: use arrows to move
;					             use spacebar to shoot
;					 for player2: use w to move up 
;					              use s to move down
;					              use d to move right
;					              use a to move left
;					             use backspace to shoot
;					 please press enter to continue
;	LogicInstructions	 To win: You must kill the enemy player
;						 Each player has health of 10 points
;						 Time is 120. When Time ends, the one
;						 with the higher health points wins.
;						 Each Obstacle has a starting of 
;						 health 9
;						 CAREFUL: You can destroy your own
;						 obstacles
;						 Each bullet, decreases 1 point from
;						 enemy or obstacle
;;

include macros.inc
.model SMALL
.stack 64
.data 
	x1p1 dw 0						;Player1 top left point X-axis
	y1p1 dw 88						;Player1 top left point Y-axis
	x1s1 dw ?						;Player1's Gun top left point X-axis
	y1s1 dw ?						;Player1's Gun top left point Y-axis
	Shoot1X	dw 400, 400, 400					;Player1's Bullet (Shot) top left point X-axis. 400 means there is no shot on the screen
	Shoot1Y	dw 400, 400, 400					;Player1's Bullet (Shot) top left point Y-axis. 400 means there is no shot on the screen
	ShootTimer1 dw 00FFFh			;Player1's Bullet movement speed

	x1p2 dw 314						;Same for Player2	
	y1p2 dw 88
	x1s2 dw ?
	y1s2 dw ?
	Shoot2X	dw 400, 400, 400
	Shoot2Y	dw 400, 400, 400
	ShootTimer2 dw 00FFFh
	
									;Obstacles Coordinates. left then right order
	ObstXCord	dw	49, 65,  33, 256, 240, 265
	ObstYCord	dw	23, 77, 125,  23,  77, 125
	ObstHealth	db 9, 9, 9, 9, 9, 9 ;Initial Health of each Obstacle is 9
	playertwohealth  db 9 
	playertwohealthsp dw ?
	playeronehealth  db 9 
	playeronehealthsp dw ?
	
									;Game Intro
	GameMode db 0				;A Variable check to check if the game has ended (WIll Exit) or it will go back to main menu.  1 if it will go back to menu. 0 Exit
	gamename db "pixelshooter$"  
	mes2     db "please enter your name:$"
	mes3     db "Waiting for player2...$"
	mes4     db " To start chatting press 1",10,13, 10,13
			 db " To start PixelShooter game press 2",10,13 ,10,13
			 db " To end the program press Esc",'$'
	pla1name db 30,?,30 dup('$')
	pla2name db 30,?,30 dup('$')
	drawname db "Draw - No one wins",'$'
	cursposx db 0Bh
	mes5     db " thank you !!",'$'
	cursposy db 0Bh
	win    db  " won !",'$'
	mes6     db "Press Esc To Exit To Main Menu"
	instructions	db" for player1: use arrows to move ",10,13
					db"              use spacebar to shoot", 10,13,10,13,10,13,10,13
					db" for player2: use w to move up ", 10,13
					db"              use s to move down", 10,13
					db"              use d to move right", 13,13
					db"              use a to move left",10,13
					db"              use backspace to shoot", 10,13,10,13,10,13
					db" please press any key to continue",'$'
	LogicInstructions	db	" To win: You must kill the enemy player",10,13
						db  " Each player has health of 10 points", 10,13
						db  " Time is 120. When Time ends, the one",10,13
						db  " with the higher health points wins.",10,13,10,13,10,13
						db  " Each Obstacle has a starting of ", 10,13
						db	" health 9", 10,13
						db  " CAREFUL: You can destroy your own",10,13
						db  " obstacles", 10,13
						db  " Each bullet, decreases 1 point from",10,13
						db  " enemy or obstacle",10,13,10,13
						db" please press any key to continue",'$'
	
	time   db  120
	tiasasci db 3 dup(?)    ;time asci to be printed as decimal on screen
	timerSpeed 	dw	0FFFFh
	timerSpeed2 db	3
	HealthPrint  db	  ?		;Player health in hexa
	HealthAsci	 db   2 dup(?)		;Value to be printed
	ValueToReceive  db   ?			;Key Press Received Value is stored here.
	valuetosend db ?
	Host		db 0				;If 0 -> Server. 1 -> Client
	
	
.code 
main proc far
	mov ax,@data
	mov ds,ax


	call Initialization				;Sets Port Initialization

	mov ah,0
	mov al,13h
	int 10h 
	; draw welcome screen gun
	DrawRect  120, 50, 10, 60, 10  ; upper part
	DrawRect  180,52,5,5,10        ; gun muzzle  
	DrawRect  120, 60,10, 10,5     ;  handle 
	DrawRect  135,60,4,1,10        ; gun trigger
	DrawRect  132,60,2,1,10        ;gun trigger 
	DrawRect  130,64,1,6,10        ;gun trigger
	DrawRect  150,60,10,10,5       ; gun magazine 
	
	
	call displaywithcolour  
	add cursposy,2
	mov cursposx,0
	call movcursor    
	call displaywithcolour2
	call readfp 
	
	call CheckPlayer2Done 
	call ExchangePlayerNames
	
	;add cursposy,2
	;mov cursposx,0h
	;call movcursor
	;call displaywithcolour3 
	;call readfp2

	;Clearing ASCII and scan code
	sub ax,ax
	
	;Choose The game or chat.. (MainMenu)
MainMenuMode:
	mov host,0 
	mov GameMode, 0			;resets it to 0.  0 = Main menue
   
	call changescreen
	mov cursposx ,0
	mov cursposy ,10 
	call movcursor 
	call displa 

	;Loop that keeps waiting for the player's input
	call MainMenueCheck		;Checks the input of thee user at mainmenue
	cmp host,0 
	jne continuemainmenumode2
	call nomove 
		continuemainmenumode2:
	;Jumps according to the gamemode that have been produced from the MainMenueCheck
	cmp GameMode, 0
	je game1
	cmp GameMode, 1
	je MainMenuMode
	cmp GameMode, 2
	je endgame
	
	;Game Mode
game1:

	;Clearing Buffer
	sub ax,ax 
	

	call InstructionsDisplay
	
	;The sender (server) will skip the instructionsDisply as the buffer has a key press
	cmp host,0
	jne continuegame1
	call nomove

	continuegame1:
	;Wait for key press to exit
	mov ah,0
	int 16h 
		
	
	
	call InstructionsLogicDisplay
	
	;Wait for key press to exit
	mov ah,0
	int 16h
	
	call CheckPlayer2Done			;Wait for player2 to finish
	call playmode 
	
	;Checks if the game should go to main menu or exit
	cmp GameMode, 1
	JNE EndGameMode
	
	;Shows the scoreboard1
	call winandlose
	;Wait for key press to exit scoreboard
	mov ah,0
	int 16h
	
	mov GameMode, 0
	call RestartGame
	
	JMP MainMenuMode
	
	;Game Ends
EndGameMode:
endgame:
	;Clears buffer
	call nomove
	sub ax, ax
	
	call changescreen
	mov cursposx,0AH
	mov cursposy,0Ah
	call movcursor 
	add cursposy,1
	call movcursor
	call displaywithcolour 
	call displayend 
	
	mov ah,0
	int 16h 
	
mov ah,4ch
int 21h
main endp 

RestartGame proc
push cx
sub cx,cx
	mov x1p1, 0
	mov y1p1, 88
	mov Shoot1X[0], 400
	mov Shoot1X[2], 400
	mov Shoot1X[4], 400
	mov Shoot1Y[0], 400
	mov Shoot1Y[2], 400
	mov Shoot1Y[4], 400

	mov x1p2 , 314
	mov y1p2 , 88
	mov Shoot2X[0], 400
	mov Shoot2X[2], 400
	mov Shoot2X[4], 400
	mov Shoot2Y[0], 400
	mov Shoot2Y[2], 400
	mov Shoot2Y[4], 400
	
	mov ObstXCord[0], 49
	mov ObstXCord[2], 65
	mov ObstXCord[4], 33
	mov ObstXCord[6], 250
	mov ObstXCord[8], 233
	mov ObstXCord[10], 265
	
	mov ObstYCord[0], 23
	mov ObstYCord[2], 77
	mov ObstYCord[4], 125
	mov ObstYCord[6], 23
	mov ObstYCord[8], 77
	mov ObstYCord[10], 113
	
	mov playertwohealth, 9
	mov playeronehealth, 9
	
	mov ObstHealth[0], 9
	mov ObstHealth[1], 9
	mov ObstHealth[2], 9
	mov ObstHealth[3], 9
	mov ObstHealth[4], 9
	mov ObstHealth[5], 9
	
	mov cursposx, 0Bh
	mov cursposy, 0Bh
	
pop cx
ret
RestartGame endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InstructionsDisplay proc
	mov ax,0600h
	mov bh,0Ah
	mov cx,0
	mov dx,184fh
	int 10h 

	mov cursposx, 0
	mov cursposy, 5
	call movcursor
	
	mov ah,9
	mov dx,offset instructions
	int 21H
ret
InstructionsDisplay endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InstructionsLogicDisplay proc
	mov ax,0600h
	mov bh,0Bh
	mov cx,0
	mov dx,184fh
	int 10h 

	mov cursposx, 0
	mov cursposy, 2
	call movcursor
	
	mov ah,9
	mov dx,offset LogicInstructions
	int 21H
ret
InstructionsLogicDisplay endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Initialization proc near
	mov dx, 3fbh		;Line control Register
	mov al, 10000000b	;Access Divisor Latch bit (1 = set divisor baud rate)
	out dx, al
	mov al, 0ch			;puts 0ch in al (9600 bits/sec)
	mov dx, 3f8h		
	out dx, al			;sets the LSB of the divisor by al (0ch)
	mov al, 00h															;000ch->9600bits/sec
	mov dx, 3f9h		;sets the MSB of the divisor by al (00)
	out dx, al
	mov dx, 3fbh		;Line Control Register
	mov al, 00011011b	;0-> Access to receiver buffer, transmitter buffer
						;0-> Sets break disabled
						;011-> Even Parity
						;0-> One Stop Bit
						;11-> Word length 8bits
	out dx, al			
	ret
Initialization endp

include fucn10.asm
include func.asm
include func2.asm 

END MAIN