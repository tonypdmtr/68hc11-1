# Translator between Roman and decimal with assembler

The program translates from Romano to decimal and vice versa sending the data to be translated via serial port to the motorola 68HC11 compiler, and the result is displayed in memory 0x50 and 0x70

## Requirements for use

- A motorola 68HC11 compiler emulator is required
- Windows OS
- Establish memory maps in addresses.
     * 8000
     * 3000s