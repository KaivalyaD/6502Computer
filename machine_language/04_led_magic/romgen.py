EEPROM_SIZE = 2**15;  # AT28C256 is a 32K EEPROM

# alternate LED state between 01010101b and 10101010b 
state_loop = bytearray([
    0xa9, 0xff,        # lda #$ff
    0x8d, 0x02, 0x60,  # sta $6002

    0xa9, 0x55,        # lda #$55
    0x8d, 0x00, 0x60,  # sta $6000
    
    0xa9, 0xaa,        # lda #$aa
    0x8d, 0x00, 0x60,  # sta $6000

    0x4c, 0x05, 0x80   # jmp $8005
])

# 8-bit ring counter
ring_counter = bytearray([
    0xa9, 0xff,        # lda #$ff
    0x8d, 0x02, 0x60,  # sta $6002

    0xa9, 0x01,        # lda #$01
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000
    0x0a,              # asl
    0x8d, 0x00, 0x60,  # sta $6000

    0x4c, 0x05, 0x80   # jmp $8005
])

code = ring_counter
padding = bytearray(
    [0xea] * (EEPROM_SIZE - len(code)),  # 0xea is the opcode for a 6502 NOP instruction
)

rom = code + padding

# reset vector #$8000 (mapped to EEPROM 0x0000)
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

with open("./rom.bin", "wb") as binfile:
    binfile.write(rom)
