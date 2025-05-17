#include <stdio.h>
#include <stdint.h>

// AT28C256 is a 32K EEPROM
#define ROMSIZE (1 << 15)

// program bytes in machine code (little-endian)
const uint8_t program[] = { };

/**
 * The 6502 is capable of addressing 64K with its 16 address lines.
 * However, we mapped the UPPER 32K of its address space with the
 * AT28C256 EEPROM.
 * 
 * This means, the EEPROM will be accessible to the 6502 from address
 * 0x8000 to 0xFFFF, and the lower 32K (i.e. 0x0000 to 0x7FFF) can be
 * kept empty for use by the 6502 to address other peripherals on its
 * address bus, such as the I/O controller.
 * 
 * However, the EEPROM, taken in isolation, is addressable in space
 * 0x0000 to 0x7FFF. This means if we were to write some data at address 'A'
 * in the EEPROM, the processor, due to the memory map we implemented, will
 * read that data at address (A + 0x8000). Conversly, if we want the processor
 * to read data from address 'B', then we must write that data to address
 * (B - 0x8000) in the EEPROM while programming it.
 * 
 * We see a consequence of that on the following line. The 6502 reset
 * vector is supposed to be stored at addresses 0xfffc and 0xfffd.
 * But we actually store the reset vector at the EEPROM addresses 0x7ffc
 * and 0x7ffd (in LITTLE ENDIAN format). Notice the difference between
 * 0xfffc and 0x7ffc (which is where the LSB of the reset vector is stored)
 * is exactly 0x8000. Same is true for the addresses of the MSB.
 * 
 * Dry Run just after power is provided to the processor and reset button is pressed:
 *  do startup sequence of 7 clock cycles
 *  lookup reset vector LSB at 0xfffc -> mapped to 0x7ffc on the EEPROM = 0x00
 *  lookup reset vector MSB at 0xfffd -> mapped to 0x7ffd on the EEPROM = 0x80
 *  jump to address 0x8000 -> mapped to 0x0000 on the EEPROM
 *  run the next instruction
 *  ...
 */

// interrupt vector table (little-endian)
const uint8_t ivt[] = {
    0xea, 0xea, /* 0xFFFA, 0xFFFB (non-maskable interrupt vector not yet defined) */
    0x00, 0x80, /* 0xFFFC, 0xFFFD (processor reset vector at 0x8000) */
    0xea, 0xea  /* 0xFFFE, 0xFFFF (regular and software interrupt vector not yet defined) */
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
