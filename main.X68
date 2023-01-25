*-----------------------------------------------------------
* Title      : Endless Runner Starter Kit
* Written by : Philip Bourke
* Date       : 25/02/2023
* Description: Endless Runner Project Starter Kit
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

INITIALISE:
    ; Initialise Sounds
    BSR     RUN_LOAD
    BSR     JUMP_LOAD

    MOVE.L  #80, $4000  ; Players X Position
    MOVE.L  #100, $4020 ; Players Y Position

    MOVE.L  #640, $4030 ; Enemy X Position
    MOVE.L  #100, $4040 ; Enemy Y Position

    MOVEQ   #17, D1 * double buffering
	MOVEQ	#92, D0 * set drawing mode to ^
	TRAP	#15

	MOVE.W  #$FF00, D1 * clear screen
	MOVEQ   #11, D0
	TRAP	#15


GAMELOOP:
    ; Main Gameloop
    BSR     INPUT
    BSR     UPDATE
    BSR     DRAW
    BRA     GAMELOOP

INPUT:
    ; Process Input
    CLR.L   D1
    MOVE.B  #19, D0
    TRAP    #15
    MOVE.B  D1, D2
    CMP.B   #0, D2
    BEQ     PROCESS_INPUT
    TRAP    #15
    
    ; Check if key still pressed
    CMP.B   #$FF, D1
    BEQ     PROCESS_INPUT
    RTS

PROCESS_INPUT:
    MOVE.B  D2, $2000
    CMP.B   #$1B,D2
    BEQ     EXIT
    CMP.B   #$20,D2
    BEQ     JUMP
    BRA     IDLE
    RTS

UPDATE:
    ;LEA    KEYCODE_MSG, A1
    ;MOVE   #14, D0
    ;TRAP   #15
    ;MOVE.B #3, D0
    ;TRAP   #15

    ;LEA    UPDATE_MSG, A1
    ;MOVE   #13, D0
    ;TRAP   #15
    SUB.L   #1, $4030
    RTS

DRAW:
    ;LEA    DRAW_MSG, A1
    ;MOVE   #13, D0
    ;TRAP   #15
    MOVEQ   #94,D0
    TRAP    #15

    MOVEQ	#11,D0
	MOVE.W	#$FF00,D1
	TRAP    #15

    BSR     DRAW_PLAYER
    BSR     DRAW_ENEMY
    RTS
    
JUMP:
    ;LEA    JUMP_MSG, A1
    ;MOVE #13, D0
    ;TRAP #15
    BSR     PLAY_JUMP
    ADD.L   #-10, $4020
    RTS
    
IDLE:
    ;LEA    IDLE_MSG, A1
    ;MOVE   #13, D0
    ;TRAP   #15
    BSR     PLAY_RUN
    RTS

RUN_LOAD:
    LEA     RUN_WAV,A1
    MOVE    #1,D1
    MOVE    #71,D0
    TRAP    #15
    RTS

PLAY_RUN:
    MOVE    #1,D1
    MOVE    #72,D0
    TRAP    #15
    TST.W   D0
    BEQ     PLAY_RUN
    RTS

JUMP_LOAD:
    LEA     JUMP_WAV,A1
    MOVE    #1,D1
    MOVE    #71,D0
    TRAP    #15
    RTS

PLAY_JUMP:
    MOVE    #1,D1
    MOVE    #72,D0
    TRAP    #15
    TST.W   D0
    BEQ     PLAY_JUMP
    RTS

DRAW_PLAYER:
    ; SET THE PIXEL COLORS
    MOVE.L  #WHITE,D1
    MOVE.B  #80,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    MOVE.L  $4000,D1
    MOVE.L  $4020,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    ADD.L   #1,D1
    ADD.L   #0,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    ADD.L   #1,D1
    ADD.L   #0,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    ADD.L   #1,D1
    ADD.L   #0,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15
    RTS

DRAW_ENEMY:
    ; SET THE PIXEL COLORS
    MOVE.L  #RED,D1
    MOVE.B  #80,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    MOVE.L  $4030,D1
    MOVE.L  $4040,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    ADD.L   #1,D1
    ADD.L   #0,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    ADD.L   #1,D1
    ADD.L   #0,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15

    ; SET X AND Y OF PIXELS
    ADD.L   #1,D1
    ADD.L   #0,D2
    
    ; DRAW PIXEL
    MOVE.B  #82,D0
    TRAP    #15
    RTS

EXIT:
    LEA     EXIT_MSG, A1
    MOVE    #13, D0
    TRAP    #15
    MOVE.B  #9, D0
    TRAP    #15
    SIMHALT

* Output Messages
KEYCODE_MSG DC.B    'KeyCode : ', 0
JUMP_MSG    DC.B    'Jump', 0
IDLE_MSG    DC.B    'Idle....', 0

UPDATE_MSG  DC.B    'Update....', 0
DRAW_MSG    DC.B    'Draw....', 0

EXIT_MSG    DC.B    'Exiting....', 0

* Screen Pixel Color
WHITE       EQU     $00FFFFFF
RED         EQU     $000000FF

* Sounds
JUMP_WAV    DC.B    'jump.wav',0
RUN_WAV     DC.B    'run.wav',0    
KEEP_WAV    DC.B    'keep_it_up.wav',0
WELL_WAV    DC.B    'well_done.wav',0
AVOID_WAV   DC.B    'avoid.wav',0
OPPS_WAV    DC.B    'opps.wav',0

    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
