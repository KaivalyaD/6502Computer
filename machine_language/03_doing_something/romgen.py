EEPROM_SIZE = 2**15;  # AT28C256 is a 32K EEPROM

rom = bytearray(
    [0xea] * EEPROM_SIZE,  # 0xea is the opcode for a 6502 NOP instruction
)

# lda #$42
rom[0x0000] = 0xa9
rom[0x0001] = 0x42

# sta $6000
rom[0x0002] = 0x8d
rom[0x0003] = 0x00
rom[0x0004] = 0x60

# reset vector #$8000 (mapped to EEPROM 0x0000)
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

with open("./rom.bin", "wb") as binfile:
    binfile.write(rom)
