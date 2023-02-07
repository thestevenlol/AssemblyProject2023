*-----------------------------------------------------------
* Title      :  Endless Runner
* Written by :  Jack Foley, C00274246
* Date       :  07/02/2023
* Description:  Pain
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

; ========== LOCATIONS ==========
HEALTH          EQU        $5000
PLAYER_X        EQU        $6000
PLAYER_Y        EQU        $6020
; ========== LOCATIONS =========



    ; ===== DATA INIT =====
    ; LOAD PLAYER X
    MOVE.B #50, PLAYER_X
    
    ; LOAD PLAYER Y
    MOVE.B #50, PLAYER_Y
    
    ; LOAD PLAYER HEALTH
    MOVE.B #100, HEALTH
    
    LEA SCORE_MEM, A1   ; LOAD SCORE
    MOVE.L  #$0, (A1)    
    
    ; ===== GRAPHICS =====
    ; DRAWING MODE
    CLR.L D0
    CLR.L D1
    MOVE.B #92, D0
    MOVE.B #17, D1
    TRAP #15
    
    ; PEN COLOUR
    CLR.L D0
    CLR.L D1
    MOVE.B #80, D0
    MOVE.L #$00FF0000, D1
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
    BRA GAMELOOP
    
INPUT:  
    MOVE.B #19, D0
    MOVE.B #$20, D1
    TRAP #15
    CMP #$FF, D1
    BEQ JUMP
    RTS
    
JUMP:
    LEA PLAYER_Y, A1
    LEA GROUND, A2
    CLR D1
    CLR D2
    MOVE.B (A1), D1
    MOVE.B (A2), D2
    CMP D1, D2 ; CHECKS IF ON GROUND, WILL ONLY JUMP IF TRUE. PREVENTS DOUBLE, TRIPLE, QUADRUPLE JUMPS, ETC.
    BEQ PERFORM_JUMP
    RTS

PERFORM_JUMP
    LEA PLAYER_Y, A1
    CLR D1
    MOVE.B (A1), D1
    ADD.B #10, D1
    MOVE.B D1, (A1)
    RTS
    
CLEAR_SCREEN:
    CLR.W D1
    MOVE.B #11, D0
    MOVE.W #$FF00, D1
    TRAP #15
    RTS
    
DRAW:
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
    

    ; BACK BUFFER - DO THIS AFTER EVERYTHING, BUT BEFORE CLEARING SCREEN
    MOVE.B #94, D0
    TRAP #15
    
    ; CLEAR SCREEN
    BSR CLEAR_SCREEN
    RTS
    
UPDATE:
    ; ADD 10 TO CURRENT SCORE
    LEA SCORE_MEM, A1
    CLR.L D1
    MOVE.L (A1), D1
    ADD #1, D1
    MOVE.L D1, (A1)
    RTS
    
    

END:
    SIMHALT             ; halt simulator

CR EQU $0D
LF EQU $0A

GROUND      DC.B        $32
SCORE_TEXT  DC.B        'Current Score: ',0
HEALTH_TEXT DC.B        'Health: ',0
B           DC.B        'B',0
C           DC.B        'C',0

SCORE_MEM       DS.L        1


    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
