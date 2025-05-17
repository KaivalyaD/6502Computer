#include <stdio.h>
#include <stdint.h>

// AT28C256 is a 32K EEPROM
#define ROMSIZE (1 << 15)

// program bytes in machine code (little-endian)
const uint8_t program[] = { };

// interrupt vector table (little-endian)
const uint8_t ivt[] = { };

// 0xEA is opcode for the 6502 NOP instruction
const uint8_t padding_byte = 0xea;

int main(void) {
    size_t program_size = sizeof(program) / sizeof(program[0]);
    size_t ivt_size = sizeof(ivt) / sizeof(ivt[0]);
    size_t padding_size = ROMSIZE - (program_size + ivt_size);

    FILE* fptr = fopen("rom.bin", "wb");
    int error = 0;

    printf("\n");

    // First, fill the file with only padding bytes.
    for(int i = 0; i < ROMSIZE; i++) {
        error = fputc(padding_byte, fptr);
        if (error == EOF) {
            printf("failed to write rom.bin\n");
            fclose(fptr);
            return 1;
        }
    }

    /*
     * Next, write the program onward location 0x0000
     * which is mapped to 0x8000 as per our memory map.
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
    printf("  padding size = %d bytes\n", padding_size);
    printf("  ivt size = %d bytes\n", ivt_size);
    printf("\n");

    return 0;
}
