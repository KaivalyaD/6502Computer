EEPROM_SIZE = 2**15;  # AT28C256 is a 32K EEPROM

rom = bytearray(
    [0xea] * EEPROM_SIZE,  # 0xea is the opcode for a 6502 NOP instruction
)

# The 6502 is capable of addressing 64K with its 16 address lines.
# However, we mapped the UPPER 32K of its address space with the
# AT28C256 EEPROM.
#
# This means, the EEPROM will be accessible to the 6502 from address
# 0x8000 to 0xffff, and the lower 32K (i.e. 0x0000 to 0x7fff) can be
# used by the 6502 to address other peripherals on the address bus,
# such as the I/O controller.
#
# However, the EEPROM, taken in isolation, is addressable in space
# 0x0000 to 0x7fff. So we have to always keep in mind to offset any
# address in the 6502 address space by -0x8000 if we want it to access
# the EEPROM.
#
# We see a consequence of that on the following line. The 6502 reset
# vector is supposed to be stored at addresses 0xfffc and 0xfffd.
# But we actually store the reset vector at the EEPROM addresses 0x7ffc
# and 0x7ffd (in the LITTLE ENDIAN format). Notice the difference
# between 0xfffc and 0x7ffc (which is where the LSB of the reset vector
# is stored) is exactly 0x8000. Same is true for the addresses of the MSB.
#
# Dry Run:
#   do startup sequence of 7 clock cycles
#   lookup reset vector LSB at 0xfffc -> mapped to 0x7ffc on the EEPROM = 0x00
#   lookup reset vector MSB at 0xfffd -> mapped to 0x7ffd on the EEPROM = 0x80
#   jump to address 0x8000 -> mapped to 0x0000 on the EEPROM
#   run the next instruction
#   ...
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

with open("./rom.bin", "wb") as binfile:
    binfile.write(rom)
