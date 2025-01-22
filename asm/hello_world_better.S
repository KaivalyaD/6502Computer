; port map
PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

; display constants
EN = %10000000 ; enable bit
RW = %01000000 ; read/write mode bit
RS = %00100000 ; register select bit

; code
 .org $8000

reset:
 lda #(EN | RW | RS) ; set EN/RW/RS pins on PORTA to output
 sta DDRA
 lda #$ff            ; set all PORTB pins to output
 sta DDRB

 lda #%00111000      ; 8-bit mode, 2-line display, 5x8 character font
 jsr lcd_instruction
 lda #%00001110      ; display on, cursor on, cursor blink off
 jsr lcd_instruction
 lda #%00000110      ; cursor goes from left to right, no display shift
 jsr lcd_instruction

 lda #RS             ; set display to write mode
 sta PORTA

; print "Hello world!!!" to display
 ldx #0              ; reset X
print_char: 
 lda message, X      ; load A with value at address (message + X)
 beq done            ; if A is 0, we are done
 jsr lcd_print       ; else, print A as a character to the display
 inx                 ; increment X by 1
 jmp print_char      ; loop back to print_char

done:
 jmp done

message:
 .ascii "Hello world!!!",$00

lcd_instruction:
 sta PORTB
 lda #0              ; clear RS/RW/EN bits
 sta PORTA
 lda #EN             ; send instruction
 sta PORTA
 lda #0              ; clear RS/RW/EN bits
 sta PORTA
 rts

lcd_print:
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN bit
 sta PORTA
 rts

; reset vector
 .org $fffc
 .word reset
 .word $0000
