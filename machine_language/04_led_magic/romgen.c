#include <stdio.h>
#include <stdint.h>

#ifndef PROGRAM
    #error A flag `PROGRAM` must be defined as 0 for state alternator, 1 for ring counter.
#endif

// AT28C256 is a 32K EEPROM
#define ROMSIZE (1 << 15)

// program bytes in machine code (little-endian)
#if (PROGRAM == 0)
    // alternate LED state between 01010101b and 10101010b
    const uint8_t program[] = {
    /* $8000 */    0xa9, 0xff,          // lda #($ff)
    /* $8002 */    0x8d, 0x02, 0x60,    // sta $6002   ; configure all Port B pins as output

    /* $8005 */    0xa9, 0x55,          // lda #($55)
    /* $8007 */    0x8d, 0x02, 0x60,    // sta $6000   ; set Port B pins to 01010101b

    /* $800a */    0xa9, 0xaa,          // lda #($aa)
    /* $800c */    0x8d, 0x00, 0x60,    // sta $6000   ; set Port B pins to 10101010b

    /* $800f */    0x4c, 0x05, 0x80,    // jmp $8005   ; jump back to address $8005
    };
#elif (PROGRAM == 1)
    // alternate LED state between 01010101b and 10101010b
    const uint8_t program[] = {
    /* $8000 */    0xa9, 0xff,          // lda #($ff)
    /* $8002 */    0x8d, 0x02, 0x60,    // sta $6002   ; configure all Port B pins as output

    /* $8005 */    0xa9, 0x01,          // lda #$01    ; set value of A to 00000001b
    /* $8007 */    0x8d, 0x00, 0x60,    // sta $6000   ; store value in A to Port B
    /* $800a */    0x0a,                // asl         ; left shift the value in A
    /* $800b */    0x8d, 0x00, 0x60,    // sta $6000   ; store value in A to Port B
    /* $800e */    0x0a,                // asl
    /* $800f */    0x8d, 0x00, 0x60,    // sta $6000
    /* $8012 */    0x0a,                // asl
    /* $8013 */    0x8d, 0x00, 0x60,    // sta $6000
    /* $8016 */    0x0a,                // asl
    /* $8017 */    0x8d, 0x00, 0x60,    // sta $6000
    /* $801a */    0x0a,                // asl
    /* $801b */    0x8d, 0x00, 0x60,    // sta $6000
    /* $801e */    0x0a,                // asl
    /* $801f */    0x8d, 0x00, 0x60,    // sta $6000
    /* $8022 */    0x0a,                // asl
    /* $8023 */    0x8d, 0x00, 0x60,    // sta $6000

    /* $8026 */    0x4c, 0x05, 0x80,    // jmp $8005   ; jump back to address $8005
    };
#else
    #error The `PROGRAM` flag can take one of only 2 values: 0 (for state alternator) or 1 (for ring counter).
#endif

// interrupt vector table (little-endian)
const uint8_t ivt[] = {
/* $fffa */    0xea, 0xea, /* undefined NMI vector */
/* $fffc */    0x00, 0x80, /* processor reset vector at 0x8000 */
/* $fffe */    0xea, 0xea  /* undefined IRQ/BRK vector */
};

// 0xEA is opcode for the 6502 NOP instruction
const uint8_t padding_byte = 0xea;

int main(void) {
    FILE* fptr = fopen("rom.bin", "wb");
    int error = 0;

    printf("\n");

    // First, fill the ROM with only padding bytes.
    for(int i = 0; i < ROMSIZE; i++) {
        error = fputc(padding_byte, fptr);
        if (error == EOF) {
            printf("failed to write rom.bin\n");
            fclose(fptr);
            return 1;
        }
    }

    size_t program_size = sizeof(program) / sizeof(program[0]);
    /*
     * Next, write the program starting from location
     * 0x0000 (mapped to 0x8000 as per our memory map).
     */
    fseek(fptr, 0x0000, SEEK_SET);
    for(int i = 0; i < program_size; i++) {
        error = fputc(program[i], fptr);
        if (error == EOF) {
            printf("failed to write rom.bin\n");
            fclose(fptr);
            return 1;
        }
    }

    size_t ivt_size = sizeof(ivt) / sizeof(ivt[0]);
    /*
     * Finally, write the interrupt vector table
     * starting at location 0x7FFA (mapped to 0xFFFA).
     */
    fseek(fptr, 0x7ffa, SEEK_SET);
    for(int i = 0; i < ivt_size; i++) {
        error = fputc(ivt[i], fptr);
        if (error == EOF) {
            printf("failed to write rom.bin\n");
            fclose(fptr);
            return 1;
        }
    }

    fclose(fptr);

    printf("Generated a directly usable binary from machine code for the 65C02S processor.\n");
    printf("  program size = %d bytes\n", program_size);
    printf("  padding size = %d bytes\n", ROMSIZE - program_size - ivt_size);
    printf("  ivt size = %d bytes\n", ivt_size);
    printf("\n");

    return 0;
}
