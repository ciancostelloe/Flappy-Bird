; SCC inPort(1:0) interrupts, toggling LED(1:0)
; Fearghal Morgan, viciLogic, 2017
;
; Description
; inPort(1:0) is SFR5(9:8)
; Use R1=0100 (bit 8 asserted) as mask for check of inPort(0) 
; Use R2=0200 (bit 9 asserted) as mask for check of inPort(1) 

SETBR R1, 8		    
SETBR R2, 9		   
SETBSFR SFR0, 1	    ; enable sw(0) interrupt
SETBSFR SFR0, 2	    ; enable sw(1) interrupt
SETBSFR SFR0, 0	    ; enable global interrupt
END	               ; end main program


ORG 92                     ; ISR(0)  5Ch, 92d. ISR0 start address (switch(0) interrupt). Could use 5Ch
MOVSFRR R0, SFR5           ; read SFR5 (inPort is upper byte) 
AND R3, R1, R0             ; mask bit 8
JNZ R3, 2                  ; LED on if inPort(0) asserted
RETI
SETBSFR SFR5, 0	    ; turn on LED(0)
RETI


ORG 104                    ; ISR(1)  68h, 104d. ISR0 start address (switch(1) interrupt). Could use 68h
SETBSFR SFR5, 1	    ; turn on LED(1)
MOVSFRR R0, SFR5           ; read SFR5 (inPort is upper byte) 
AND R3, R2, R0             ; mask bit 9
JNZ R3, 2                  ; LED on if inPort(1) asserted
RETI
SETBSFR SFR5, 1	    ; turn on LED(1)


ORG 116                    ; Timer ISR 74h 116d. ISR2 start address (timer interrupt). Could use 74h                  
RETI       	                ; return from interrupt