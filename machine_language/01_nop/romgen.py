EEPROM_SIZE = 2**15;  # AT28C256 is a 32K EEPROM

rom = bytearray(
    [0xEA] * EEPROM_SIZE  # 0xea is the opcode for a 6502 NOP instruction
)

with open("./rom.bin", "wb") as binfile:
    binfile.write(rom)
