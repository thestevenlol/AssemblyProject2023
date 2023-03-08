*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:
    
    ; SETUP    
    
    ; MEMORY DEFINITION
HEALTH          EQU         $5000
SCORE           EQU         $5020
PLAYER_X        EQU         $6000
PLAYER_Y        EQU         $6020
PLAYER_VEL      EQU         $6040
PLAYER_JUMPING  EQU         $6041
ENEMY_X         EQU         $7000
ENEMY_Y         EQU         $7010
ENEMY_W         EQU         $7020
ENEMY_H         EQU         $7030
    
    ; LOAD MEMORY
    MOVE.B #100, HEALTH
    MOVE.W #200, PLAYER_X
    MOVE.W #600, PLAYER_Y
    MOVE.B #0,   PLAYER_VEL
    MOVE.W #600, ENEMY_X
    
    BSR RANDOM_NUM_THREE
    MOVE.W #600, D2
    SUB.W D1, D2
    MOVE.W D2, ENEMY_Y
    CLR.L D1
    CLR.L D2
    
    BSR RANDOM_NUM_ONE
    MOVE.W D1,   ENEMY_W
    BSR RANDOM_NUM_TWO
    MOVE.W D1,   ENEMY_H
    
    ; INITIALISE DRAWING MODE
    MOVE.B #92, D0
    MOVE.B #17, D1
    TRAP #15
    CLR.B D0
    CLR.B D1
    
    ; SET WINDOW SIZE
    MOVE.B #33, D0
    MOVE.L #1000*$10000+800, D1
    TRAP #15
    CLR.L D0
    CLR.L D1
    
    ; TIME
    MOVE.B #08, D0
    TRAP #15
    MOVE.L D1, D2
    
    BRA GAMELOOP

RANDOM_NUM_ONE:
    CLR.L D0
    CLR.L D1
    MOVE.B #8, D0
    TRAP #15
    
    AND.L #$000FFFFF, D1 ; PREVENT OVERFLOW
    DIVU #50, D1
    SWAP D1
    ADDQ.W #8, D1
    MOVE.W D1, D2
    CLR.L D1
    MOVE.W D2, D1
    CLR.L D2
    
    RTS
    
RANDOM_NUM_TWO:
    CLR.L D0
    CLR.L D1
    MOVE.B #8, D0
    TRAP #15
    
    AND.L #$000FFFFF, D1 ; PREVENT OVERFLOW
    DIVU #30, D1
    SWAP D1
    ADDQ.W #8, D1
    MOVE.W D1, D2
    CLR.L D1
    MOVE.W D2, D1
    CLR.L D2
    
    RTS
    
RANDOM_NUM_THREE:
    CLR.L D0
    CLR.L D1
    MOVE.B #8, D0
    TRAP #15
    
    AND.L #$000FFFFF, D1 ; PREVENT OVERFLOW
    DIVU #30, D1
    SWAP D1
    MOVE.W D1, D2
    CLR.L D1
    MOVE.W D2, D1
    CLR.L D2
    
    RTS

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
    CMP #1, D3
    BLT TICK
    MOVE.L D1, D2
    RTS
    
GAMELOOP:
    BSR TICK
    BSR DRAW
    BSR UPDATE
    BSR INPUT
    
    ; TIME
    MOVE.B #08, D0
    TRAP #15
    MOVE.L D1, D2
    
    BRA GAMELOOP

; DRAWING START

DRAW:
    BSR DRAW_GROUND
    BSR DRAW_SCORE
    BSR LOWER_CURSOR
    BSR DRAW_HEALTH
    BSR DRAW_PLAYER
    BSR DRAW_ENEMY
    BSR BACK_BUFFER
    BSR CLEAR_SCREEN
    RTS
    
LOWER_CURSOR:
    MOVE.W #$0001, D1
    MOVE.B #11, D0
    TRAP #15
    CLR.L D0
    CLR.L D1
    RTS

DRAW_GROUND:
    MOVE.W #0, D1
    MOVE.W #600, D2
    MOVE.W #1000, D3
    MOVE.W #600, D4
    MOVE.B #84, D0
    TRAP #15
    
    CLR.L D0
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    RTS

DRAW_SCORE:
    MOVE.B #17, D0
    LEA SCORE_TEXT, A1
    LEA SCORE_MEM, A2
    MOVE.L (A2), D1
    TRAP #15
    CLR.L D0
    CLR.L D1
    RTS
    
DRAW_HEALTH:
    LEA HEALTH_TEXT, A1
    LEA HEALTH, A2
    MOVE.B #17, D0
    MOVE.B (A2), D1
    TRAP #15
    CLR.L D0
    CLR.L D1
    RTS
    
BACK_BUFFER:
    MOVE.B #94, D0
    TRAP #15
    CLR.L D0
    RTS
    
CLEAR_SCREEN:
    MOVE.B #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    CLR.L D0
    CLR.L D1
    RTS
    
DRAW_PLAYER:
    LEA PLAYER_X, A1
    LEA PLAYER_Y, A2
    MOVE.W #10, D7
    MOVE.W (A2), D6
    MOVE.W (A1), D5
    
    SUB.W D7, D6
    
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
    
    ; CLEAR DATA REGISTERS
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    CLR.L D5
    CLR.L D6
    CLR.L D7
    
    ; RETURN
    RTS
    
DRAW_ENEMY:
    LEA ENEMY_X, A1
    LEA ENEMY_Y, A2
    LEA ENEMY_W, A3
    LEA ENEMY_H, A4
    MOVE.W (A2), D6 ; Y
    MOVE.W (A1), D5 ; X
    
    MOVE.W (A4), D7
    SUB.W D7, D6
    
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    
    ; LEFT X
    MOVE.W (A3), D7
    MOVE.W D5, D1
    SUB.W D7, D1
    
    ; UPPER Y
    MOVE.W (A4), D7
    MOVE.W D6, D2
    SUB.W D7, D2
    
    ; RIGHT X
    MOVE.W (A3), D7
    MOVE.W D5, D3
    ADD.W D7, D3
    
    ; UPPER Y
    MOVE.W (A4), D7
    MOVE.W D6, D4
    ADD.W D7, D4
    
    ; TRAP
    CLR.L D0
    MOVE.B #90, D0
    TRAP #15
    
    CLR.L D0
    CLR.L D1
    CLR.L D2
    CLR.L D3
    CLR.L D4
    
    ; RETURN
    RTS


; DRAWING END

; UPDATING START
    
UPDATE:
    BSR UPDATE_SCORE
    BSR UPDATE_PLAYER_POS
    BSR UPDATE_ENEMY_POS
    BSR CHECK_COLLISION
    RTS
    
UPDATE_SCORE:
    LEA SCORE_MEM, A1
    MOVE.L (A1), D1
    ADD.L #1, D1
    MOVE.L D1, (A1)
    CLR.L D1
    RTS
    
UPDATE_PLAYER_POS:
    LEA PLAYER_Y, A1
    LEA PLAYER_VEL, A2
    LEA GROUND, A3
    LEA PLAYER_JUMPING, A4
    
    MOVE.W (A1), D1
    MOVE.B (A2), D2
    MOVE.W (A3), D3
    MOVE.B (A4), D4
    
    CMP #1, D4
    BEQ JUMPING
    
    CMP #2, D4
    BEQ FALLING
    
    RTS
    
JUMPING:
    CMP #0, D2
    BEQ DONE_JUMPING

    SUB.W D2, D1
    MOVE.W D1, (A1)
    SUB.B #1, D2
    MOVE.B D2, (A2)
    CLR.L D1
    CLR.L D2
    RTS
    
DONE_JUMPING:
    MOVE.B #2, (A4)
    CLR.L D4
    RTS
    
FALLING:
    CMP #20, D2
    BEQ DONE_FALLING
    
    ADD.W D2, D1
    MOVE.W D1, (A1)
    ADD.B #1, (A2)
    CLR.L D1
    CLR.L D2
    RTS

DONE_FALLING:
    ADD.W D2, D1
    MOVE.W D1, (A1)
    MOVE.B #0, (A2)
    MOVE.B #0, (A4)
    CLR.L D2
    CLR.L D4
    RTS
    
UPDATE_ENEMY_POS:
    ; GET CURRENT X
    LEA ENEMY_X, A1
    CLR.L D1
    MOVE.W (A1), D1
    
    ; CHECK IF OFF SCREEN
    CMP.W #0, D1
    BLE RESET_ENEMY_POS
    
    SUB.W #20, D1
    MOVE.W D1, (A1)
    RTS
    
RESET_ENEMY_POS:
    LEA ENEMY_W, A1
    MOVE.W (A1), D1
    CLR.L D1
    BSR RANDOM_NUM_ONE
    MOVE.W D1, (A1)
    
    LEA ENEMY_H, A1    
    MOVE.W (A1), D1
    CLR.L D1
    BSR RANDOM_NUM_TWO
    MOVE.W D1, (A1)
    
    BSR RANDOM_NUM_THREE
    MOVE.W #600, D2
    SUB.W D1, D2
    MOVE.W D2, ENEMY_Y
    CLR.L D1
    CLR.L D2
    
    LEA ENEMY_X, A1
    MOVE.W #1000, (A1)
    RTS
    
CHECK_COLLISION:
    CLR.L D1
    CLR.L D2
    CLR.L D3
 
* (pX <= eX + eW) && (pX + pW >= eX) && (pY <= eY + eH) && (pY + pH >= eY)


CHECK_PX_LTE_EX_PLS_EW:
    MOVE.W PLAYER_X, D1
    MOVE.W ENEMY_X, D2
    ADD.W ENEMY_W, D2
    CMP D1, D2
    BLE CHECK_PX_PLS_PW_GTE_EX
    RTS
    
CHECK_PX_PLS_PW_GTE_EX
    MOVE.W ENEMY_X, D1
    MOVE.W PLAYER_X, D2
    ADD.W #10, D2
    CMP D2, D1
    BGE CHECK_PY_LTE_EY_PLS_EH
    RTS
    
CHECK_PY_LTE_EY_PLS_EH:
    MOVE.W PLAYER_Y, D1
    MOVE.W ENEMY_Y, D2
    ADD.W ENEMY_H, D2
    CMP D1, D2
    BLE CHECK_PY_PLS_PH_GTE_EY
    RTS
    
CHECK_PY_PLS_PH_GTE_EY:
    MOVE.W ENEMY_Y, D1
    MOVE.W PLAYER_Y, D2
    ADD.W #10, D2
    CMP D2, D1
    BGE COLLISION
    RTS
    
COLLISION:
    LEA SCORE_MEM, A1
    MOVE.L #0, (A1)
    
    LEA HEALTH, A1
    MOVE.B (A1), D1
    SUB.B #10, D1
    MOVE.B D1, (A1)
    CLR.L D1
    
    BSR CHECK_HEALTH
    BEQ DEATH
    
    RTS
    
CHECK_HEALTH:
    MOVE.B (A1), D1
    CMP.B #0, D1
    RTS

    
; UPDATING END

; INPUT START

INPUT:
    BSR CHECK_SPACE
    BEQ ON_GROUND
    RTS

START_JUMP:
    LEA PLAYER_VEL, A1
    MOVE.B #20, (A1)
    LEA PLAYER_JUMPING, A1
    MOVE.B #1, (A1)
    CLR.L D1
    CLR.L D2
    RTS

CHECK_SPACE:
    MOVE.B #19, D0
    MOVE.B #$20, D1
    TRAP #15
    CMP #$FF, D1
    RTS
    
ON_GROUND
    LEA PLAYER_Y, A1
    LEA GROUND, A2
    
    MOVE.W (A1), D1
    MOVE.W (A2), D2
    
    CMP D1, D2
    BEQ START_JUMP
    RTS
    
; INPUT END
    
END_TXT:
    ;SET CURSOR
    CLR.L D0
    MOVE.B #11, D0
    MOVE.W #$7F40, D1
    TRAP #15
    
    ;PRINT MESSAGE
    MOVE.B #14, D0
    LEA END_MESSAGE, A1
    TRAP #15
    
    RTS
    
DEATH:
    BSR CLEAR_SCREEN
    BSR END_TXT
    BSR BACK_BUFFER
    
    SIMHALT
    
SCORE_MEM   DS.L        1
SCORE_TEXT  DC.B        'Current Score: ',0
HEALTH_TEXT DC.B        'Health: ',0
END_MESSAGE DC.B        'GAME OVER',0
GROUND      DC.W        $258
    
    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
