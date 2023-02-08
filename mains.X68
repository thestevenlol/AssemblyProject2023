*-----------------------------------------------------------
* Title      :  Endless Runner
* Written by :  Jack Foley, C00274246
* Date       :  07/02/2023
* Description:  Pain
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

; ========== LOCATIONS ==========
HEALTH          EQU         $5000
PLAYER_X        EQU         $6000
PLAYER_Y        EQU         $6020
PLAYER_Y_VEL    EQU         $6040
; ========== LOCATIONS ==========



    ; ===== DATA INIT =====
    ; LOAD PLAYER X
    MOVE.W #200, PLAYER_X
    
    ; LOAD PLAYER Y
    MOVE.W #600, PLAYER_Y
    
    ; LOAD PLAYER Y VELOCITY
    MOVE.B #0, PLAYER_Y_VEL
    
    ; LOAD PLAYER HEALTH
    MOVE.B #100, HEALTH
    
    LEA SCORE_MEM, A1   ; LOAD SCORE
    MOVE.L  #$0, (A1)    
    
    ; SET WINDOW SIZE
    MOVE.B #33, D0
    MOVE.L #1000*$10000+800, D1
    TRAP #15
    
    ; ===== GRAPHICS =====
    ; DRAWING MODE
    CLR.L D0
    CLR.L D1
    MOVE.B #92, D0
    MOVE.B #17, D1
    TRAP #15
    
    ; PEN WIDTH
    CLR.L D0
    CLR.L D1
    MOVE.B #93, D0
    MOVE.B #$1, D1
    TRAP #15

GAMELOOP:
    BSR INPUT
    BSR UPDATE
    BSR DRAW
    BSR DELAY
    BRA GAMELOOP
      
DELAY:
    RTS
    
INPUT:  
    MOVE.B #19, D0
    MOVE.B #$20, D1
    TRAP #15
    CMP #$FF, D1
    BEQ JUMP
    BNE JUMP_FALL
    RTS
    
JUMP:
    ; INIT VELOCITIES
    LEA PLAYER_JUMP_VEL, A1
    MOVE.B (A1), PLAYER_Y_VEL
    RTS

JUMP_FALL:
    LEA PLAYER_Y, A1
    LEA GROUND, A2
    
    CLR.W D1
    CLR.W D2
    
    MOVE.W (A1), D1
    MOVE.W (A2), D2
    
    CMP D1, D2
    BNE CHECK_HEIGHT
    RTS
    
CHECK_HEIGHT:
    LEA PLAYER_Y, A1
    LEA MAX_JUMP_HEIGHT, A2
    
    CLR.L D1
    CLR.L D2
    
    MOVE.W (A1), D1
    MOVE.W (A2), D2
    
    CMP D1, D2
    BEQ PERFORM_JUMP_FALL
    RTS
    
PERFORM_JUMP_FALL:
    ADD.W #100, (A1)
    RTS
    
    
; ========== DRAWING ==========
    
CLEAR_SCREEN:
    CLR.W D1
    MOVE.B #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    RTS
    
DRAW:
    ; DRAW GROUND
    CLR.L D0
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    MOVE.W #0, D1
    MOVE.W #600, D2
    MOVE.W #1000, D3
    MOVE.W #600, D4
    MOVE.B #84, D0
    TRAP #15
    
    ; DRAW SCORE
    CLR.L D0
    MOVE.B #17, D0
    LEA SCORE_TEXT, A1
    LEA SCORE_MEM, A2
    MOVE.L (A2), D1
    TRAP #15

    ; MOVE CURSOR DOWN 1 ROW
    CLR.L D1
    MOVE.W #$0001, D1
    MOVE.B #11, D0
    TRAP #15
    
    ; DRAW HEALTH
    CLR.L D0
    CLR.L D1
    LEA HEALTH_TEXT, A1
    LEA HEALTH, A2
    MOVE.B #17, D0
    MOVE.B (A2), D1
    TRAP #15
    
    BSR DRAW_PLAYER

    ; BACK BUFFER - DO THIS AFTER EVERYTHING, BUT BEFORE CLEARING SCREEN
    MOVE.B #94, D0
    TRAP #15
    
    ; CLEAR SCREEN
    BSR CLEAR_SCREEN
    RTS
    
DRAW_PLAYER:
    LEA PLAYER_X, A1
    LEA PLAYER_Y, A2
    MOVE.W #10, D7
    MOVE.W (A2), D6
    MOVE.W (A1), D5
    
    SUB.W D7, D6
    
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    
    ; LEFT X
    MOVE.W D5, D1
    SUB.W D7, D1
    
    ; UPPER Y
    MOVE.W D6, D2
    SUB.W D7, D2
    
    ; RIGHT X
    MOVE.W D5, D3
    ADD.W D7, D3
    
    ; UPPER Y
    MOVE.W D6, D4
    ADD.W D7, D4
    

    
    ; TRAP
    CLR.L D0
    MOVE.B #90, D0
    TRAP #15
    
    ; RETURN
    RTS
    
    
; ========== DRAWING ==========




; ========== UPDATING ==========
    
UPDATE:
    ; ADD 10 TO CURRENT SCORE
    LEA SCORE_MEM, A1
    CLR.L D1
    MOVE.L (A1), D1
    ADD.L #1, D1
    MOVE.L D1, (A1)
    
    ; PLAYER Y UPDATE
    LEA PLAYER_Y, A1
    LEA MAX_JUMP_HEIGHT, A2
    CLR.L D1
    CLR.L D2
    MOVE.W (A1), D1
    MOVE.W (A2), D2
    
    CMP D1, D2
    BNE SUB_PLAYER_Y_VEL
    RTS
    
SUB_PLAYER_Y_VEL:
    SUB.B #1, PLAYER_Y_VEL
    RTS
    
; ========== UPDATING ==========
    
    

END:
    SIMHALT             ; halt simulator

CR EQU $0D
LF EQU $0A

SCORE_MEM   DS.L        1

GROUND      DC.W        $258
MAX_JUMP_HEIGHT DC.W    $1F4

SCORE_TEXT  DC.B        'Current Score: ',0
HEALTH_TEXT DC.B        'Health: ',0
PLAYER_JUMP_VEL DC.B         $5  ; INITIAL JUMP VELOCITY
GRAVITY         DC.B         $1     


    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
