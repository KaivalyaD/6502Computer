; port map
PORTB = $6000
PORTA = $6001
DDRB  = $6002  ; data direction register for Port B
DDRA  = $6003  ; data direction register for Port A

; display constants
EN = %10000000 ; enable bit
RW = %01000000 ; read/write mode bit
RS = %00100000 ; register select bit

; code
 .org $8000

reset:
main:
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
 lda #%00000001      ; clear display
 jsr lcd_instruction

 lda #RS             ; set display to write mode
 sta PORTA

; print a message_1 to display
 ldx #0              ; reset X
print_message_1: 
 lda message_1, X    ; load A with value at address (message_1 + X)
 beq message_1_over  ; if A is 0, we are done
 jsr lcd_print       ; else, print A as a character to the display
 inx                 ; increment X by 1
 jmp print_message_1 ; loop back to print_message_1
message_1_over:

; delay for a few (slow or debugging mode clock) cycles
 lda #10             ; load A with 10
delay:
 sbc #1              ; subtract 1 from A
 beq delay_over      ; if A is 0, delay is over
 jmp delay           ; else, loop back to delay
delay_over:

clear_lcd:
 lda #%00000001      ; clear display
 jsr lcd_instruction
 lda #%00000010      ; return cursor to home
 jsr lcd_instruction

; print a message_2 to display
 ldx #0              ; reset X
print_message_2: 
 lda message_2, X    ; load A with value at address (message_2 + X)
 beq message_2_over  ; if A is 0, we are done
 jsr lcd_print       ; else, print A as a character to the display
 inx                 ; increment X by 1
 jmp print_message_2 ; loop back to print_message_2
message_2_over:

done_loop:
 jmp done_loop

message_1:
 .ascii "Hello world!!!                          Debayan :)",$00

message_2:
 .ascii "^%*(){}[]&@                        /?!@#$%^&*{}:;<>",$00

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
