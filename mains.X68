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
PLAYER_VEL      EQU         $6040

LAST_KEY        EQU         $5020

ENEMY_X         EQU         $7000
ENEMY_Y         EQU         $7020
; ========== LOCATIONS =========



    ; ===== DATA INIT =====
 
    ; LOAD PLAYER X
    MOVE.W #200, PLAYER_X
    
    ; LOAD PLAYER Y
    MOVE.W #600, PLAYER_Y
    
    ; LOAD PLAYER Y VELOCITY
    MOVE.B #0, PLAYER_Y_VEL
    
    ; LOAD PLAYER HEALTH
    MOVE.B #100, HEALTH
    
    ; LOAD ENEMY X
    MOVE.W #600, ENEMY_X
    
    ; LOAD ENEMY Y
    MOVE.W #600, ENEMY_Y
    
    ; LOAD PLAYER VELOCITY
    MOVE.B #0,   PLAYER_VEL
    
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
    
    ; TIME
    MOVE.B #08, D0
    TRAP #15
    MOVE.L D1, D2
    
    BRA GAMELOOP

TICK:
    ; PREV = D2
    ; GET CURRENT INTO D1 AND D3
    ; SUB D2, D3
    ; CMP D3

    CLR.L D0
    MOVE.B #08, D0
    TRAP #15
    
    MOVE.L D1, D3
    
    SUB.L D2, D3
    CMP #2, D3
    BLT TICK
    MOVE.L D1, D2
    RTS
    
GAMELOOP:
    BSR TICK
    BSR INPUT
    BSR UPDATE
    BSR DRAW
    
    ; TIME
    MOVE.B #08, D0
    TRAP #15
    MOVE.L D1, D2

    BRA GAMELOOP
      
DELAY:
    RTS
    
    
INPUT:  
    MOVE.B #19, D0
    MOVE.B #$20, D1
    TRAP #15
    CMP #$FF, D1
    BEQ JUMP_INIT
    RTS
    
JUMP_INIT:
    ; GET PLAYER Y AND GROUND Y
    ; CHECK IF ON GROUND
    ; IF YES, SET PLAYER_VEL TO MAX_VEL
    ; BSR JUMP
    
    ; PLAYER Y
    LEA $6020, A1
    CLR.L D1
    MOVE.W (A1), D1
    
    ; GROUND
    CLR.L D2
    MOVE.W GROUND, D2
    
    CMP D1, D2
    BEQ JUMP
    RTS
    
    
JUMP:
    ; LOAD VEL INTO A1 AND D1
    LEA PLAYER_VEL, A1
    CLR.L D1
    MOVE.B (A1), D1    
 
    ; CHECK IF ZERO
    CMP #0, D1
    BEQ LOAD_VEL
    
    ; LOAD PLAYER_Y
    LEA PLAYER_Y, A2
    CLR.L D2
    MOVE.W (A2), D2
    
    ; ADD VEL TO PLAYER Y
    SUB.W D1, D2
    
    ; MOVE PLAYER Y BACK TO MEM
    MOVE.W D2, (A2)
    
    ; DECREMENT VEL
    SUB.B #4, D1
    
    ; MOVE VEL BACK TO MEM
    MOVE.B D1, (A1)

    ; VEL IS CHECK AGAIN IN UPDATE,
    ; IF IT IS NOT ZERO, RUN THIS SUBROUTINE AGAIN
    
    RTS
 
LOAD_VEL:
    MOVE.B MAX_VEL, D1
    MOVE.B D1, (A1)
    RTS
 
FALL:
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
    BSR DRAW_ENEMY

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
    
DRAW_ENEMY:
    LEA ENEMY_X, A1
    LEA ENEMY_Y, A2
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
    
    ; UPDATE ENEMY POS
    
    ; GET CURRENT X
    LEA ENEMY_X, A1
    CLR.L D1
    MOVE.W (A1), D1
    
    ; CHECK IF OFF SCREEN
    CMP.W #0, D1
    BLE RESET_ENEMY_POS
    
    SUB.W #10, D1
    MOVE.W D1, (A1)
    
    ; JUMPING
    ; LOAD PLAYER VEL INTO A1 AND D1
    LEA PLAYER_VEL, A1
    CLR.L D1
    MOVE.B (A1), D1
    
    MOVE.B #19, D0
    MOVE.B #$20, D1
    TRAP #15
    CMP #$FF, D1
    BEQ JUMP_UPDATE
    
    RTS
    
JUMP_UPDATE:
    ; CHECK IF VEL IS NOT ZERO
    CMP #0, D1
    BGT JUMP
    
    RTS
  
RESET_ENEMY_POS:
    MOVE.W #999, (A1)
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
MAX_VEL     DC.B        $20

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
