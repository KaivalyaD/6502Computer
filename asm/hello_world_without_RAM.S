; Can run without RAM! But very, very hard to maintain or extend!

; port map
PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

; display constants
EN = %10000000       ; enable bit
RW = %01000000       ; read/write mode bit
RS = %00100000       ; register select bit

; code
 .org $8000

reset:
 lda #(EN | RW | RS) ; set EN/RW/RS pins on PORTA to output
 sta DDRA
 lda #$ff            ; set all PORTB pins to output
 sta DDRB

 lda #%00111000      ; 8-bit mode, 2-line display, 5x8 character font
 sta PORTB
 lda #0              ; clear RS/RW/EN bits
 sta PORTA
 lda #EN             ; send instruction
 sta PORTA
 lda #0              ; clear RS/RW/EN bits
 sta PORTA

 lda #%00001110      ; display on, cursor on, blink off
 sta PORTB
 lda #0              ; clear RS/RW/EN bits
 sta PORTA
 lda #EN             ; send instruction
 sta PORTA
 lda #0              ; clear RS/RW/EN bits
 sta PORTA

 lda #%00000110      ; cursor goes from left to right, no display shift
 sta PORTB
 lda #0              ; clear RS/RW/EN bits
 sta PORTA
 lda #EN             ; send instruction
 sta PORTA
 lda #0              ; clear RS/RW/EN bits
 sta PORTA

 lda #RS             ; set display to write mode
 sta PORTA

 lda #"H"            ; send data "H"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"e"            ; send data "e"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"l"            ; send data "l"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"l"            ; send data "l"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"o"            ; send data "o"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"w"            ; send data "w"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"o"            ; send data "o"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"r"            ; send data "r"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"l"            ; send data "l"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"d"            ; send data "d"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"!"            ; send data "!"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"!"            ; send data "!"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"!"            ; send data "!"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"-"            ; send data "-"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"K"            ; send data "K"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"a"            ; send data "a"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"i"            ; send data "i"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"v"            ; send data "v"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"a"            ; send data "a"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"l"            ; send data "l"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"y"            ; send data "y"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"a"            ; send data "a"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #" "            ; send data " "
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #":"            ; send data ":"
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

 lda #"("            ; send data "("
 sta PORTB
 lda #(EN | RS)      ; send data
 sta PORTA
 lda #RS             ; clear EN
 sta PORTA

loop:
 jmp loop

; reset vector
 .org $fffc
 .word reset
 .word $0000
