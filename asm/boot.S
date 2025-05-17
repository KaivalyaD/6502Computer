; This logic ain't gonna work! You may fetch the main() into memory, but what about other labels?

READ_PAGE = $00         ; 2 bytes in zero page
WRITTEN_PAGE = $02      ; 2 bytes in zero page

PROCESS_START = $0200   ; user process start address from page 2 of RAM (15.25KiB = 61 pages)
ISR = $3f00             ; user regular ISR in page 63 of RAM (top 128 bytes)
NMISR = $3f80           ; user non-maskable ISR in page 63 of RAM (bottom 128 bytes)
FILE_START = $8100      ; user program file start address in ROM

    .org $8000
RESET:
    ldx #$ff            ; start stack at 0x1ff
    txs

    clc                 ; clear carry flag
    cld                 ; clear decimal mode

    lda #<FILE_START
    sta READ_PAGE
    lda #>FILE_START
    sta READ_PAGE + 1

    lda #<PROCESS_START
    sta WRITTEN_PAGE
    lda #>PROCESS_START
    sta WRITTEN_PAGE + 1

START_LOADER:
NEXT_PAGE:
    ldy #0

COPY_LOOP:
    lda (READ_PAGE), Y      ; a = *(*READ_PAGE + y)
    sta (WRITTEN_PAGE), Y   ; *(*WRITTEN_PAGE + y) = a
    iny                     ; ++y
    tya
    cmp #$ff                ; if(y != 0xff)
    bne COPY_LOOP           ; then go back to COPY_LOOP
    lda (READ_PAGE), Y      ; else
    sta (WRITTEN_PAGE), Y   ; load last byte and proceed below

    clc                     ; clear carry bit
    lda READ_PAGE + 1
    adc #1                  ; try going to the next READ_PAGE: increment high byte of READ_PAGE
    bcs E_TOO_MANY_PAGES    ; if high byte of READ_PAGE > 0xff, we've detected an illegal address; hangup
    sta READ_PAGE + 1       ; address is legal, update high byte of READ_PAGE and proceed below

    lda WRITTEN_PAGE + 1
    adc #1                  ; try going to the next WRITTEN_PAGE: increment high byte of WRITTEN_PAGE
    cmp #$40
    beq E_OUT_OF_MEMORY     ; if high byte of WRITTEN_PAGE >= 0x40, we are OOM'ed; hangup
    sta WRITTEN_PAGE + 1    ; address is legal, update high byte of WRITTEN_PAGE
    jmp NEXT_PAGE           ; start loading the next page

E_TOO_MANY_PAGES:
    jmp HANGUP

E_OUT_OF_MEMORY:
    jmp HANGUP

HANGUP:
    jmp HANGUP

LOADING_DONE:
    jmp PROCESS_START       ; loading complete, hand control over to the loaded process

    .org $fffa
VECTOR_LOCATIONS:
    .word NMISR             ; non-maskable interrupt service routine at {0xfffa, 0xfffb}
    .word RESET             ; reset vector at {0xfffc, 0xfffd}
    .word ISR               ; regular interrupt service routine at {0xfffe, 0xffff}
