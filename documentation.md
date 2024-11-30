# WOS88 - A reimagining of the WOS8 Virtual Microprocessor.
## Designed by Bogg
Homepage: https://bogg-cpu.github.io/home
# Overview
WOS88 (Wired Output System 88) is an early 1980's inspired microprocessor designed to be easily improved and expanded by knowledgeable end-users.
Devices are easy to design, create and attach to the machine.

# Comparisons

Here is a list of comparisons between the WOS88 and the WOS8:

### WOS88

Memory Mapped and Interrupt Driven I/O Interface

- Fast, hardware-level peripheral access
- Straightforward hardware interaction

Machine-Readable Program

- Capable of self-modifying code
- Minimal decoding needed
- Programmers need a suitable compiler

Subroutine Instructions

- Complex program flow is readily available

### WOS8

Interrupt Driven I/O Interface

- Easy to expand and program on
- Popular I/O Method
- Nested Interrupts can cause issues

Human-Interpretable Program

- Requires decoders to interpret the program in memory
- Incapable of self-modifying code

# Specifications

- 6 General Purpose Registers (GPRs)
- 3 Specialized Registers
- 31 Instructions
- 3 Byte Instructions
- Interrupt & Memory Mapped I/O modes
- 65k Core, extended memory options
- Subroutine capabilities
- 256 Byte Stack

<br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br>

# Operations

Operations on the WOS88 are formed with three words; the Operation word, the Source word and the Target word.

As such, operations may be written as followed:

<span style="font-size: 15px; font-weight: bold;">24 04 02</span> (XOR D Register into B Register)

### Following is the operation table:
| ID  | Mnemonic |  Name          | Description                                                                  |
| --- | -------- | -------------- | ---------------------------------------------------------------------------- |
| 00  | NOP      | No Operation   | Ignores Source and Target values.                                            |
| 01  | ADD      | Addition       | Adds the Source value to the Target.                                         |
| 02  | SUB      | Subtraction    | Subtracts the Source value from the Target.                                  |
| 03  | MUL      | Multiplication | Multiplies the Source value to the Target.                                   |
| 04  | DIV      | Division       | Divides the Source value from the Target.                                    |
| 05  | INC      | Increment      | Adds 1 to the Target.                                                        |
| 06  | DEC      | Decrement      | Subtracts 1 from the Target.                                                 |
| 07  | MOV      | Move           | Copies the Source register to the Target.                                    |
| 08  | MPT      | Memory Point   | Sets the Memory Access Register to the Target.                               |
| 09  | LOD      | Load To Memory | Loads the address at MAR, and copies to Target.                              |
| 10 | STO      | Store             | Stores the Target value at the address MAR.                                |
| 11 | JMP      | Jump              | Sets the Program Counter to the Target value.                              |
| 12 | JF       | Jump If Flag      | Sets the PC to the Target value if the flag at Source is true.             |
| 13 | JNF      | Jump If Not Flag  | Sets the PC to the Target value if the flag at Source is false.            |
| 14 | JSR      | Jump to Subroutine| Pushes the current PC to the stack, and jumps to the specified subroutine. |
| 15 | RTS      | Return from Subroutine | Sets the PC to the return value popped from the stack.                |
| 16 | USO      | Unsupported Opcode| Does nothing.                                                              |
| 17 | USO      | Unsupported Opcode| Does nothing.                                                              |
| 18 | MIM      | Move Immediate    | Copies the Source value to the Target.                                     |
| 19 | AND      | Bitwise AND       | Performs an AND operation with Source and Target.                          |
| 20 | OR       | Bitwise OR            | Performs an OR operation with Source and Target.                       |
| 21 | XOR      | Bitwise XOR           | Performs an XOR operation with Source and Target.                      |
| 22 | NOT      | Bitwise NOT           | Negates Target, copying Target to itself.                              |
| 23 | SHL      | Bitwise Shift Left    | Shifts the Target left, Source times.                                  |
| 24 | SHR      | Bitwise Shift Right   | Shifts the Target right, Source times.                                 |
| 25 | YIR      | Yield IRQ             | If an IRQ is pending, begin the IRQ handler.                           |
| 26 | HLI      | Halt Until IRQ        | Halt execution until an IRQ is received.                               |
| 27 | RTI      | Return From Interrupt | If the CPU is in an IRQ state, exit and restore state.                 |
| 28 | PSH      | Push To Stack         | Copies the Source to the Stack, and increment SP by 1.                 |
| 29 | POP      | Pop From Stack        | Copies the Stack’s top to Target, and decrement SP by 1.               |
| 30 | HLT      | Halt   | Halts the execution of the processor. Non-reversible.                                 |
| 31 | REM      | Remark | Ignored by the compiler. Intended for programmer notes.                               |

<br></br>
# Registers
WOS88 features six General Purpose Registers (GPRs) and four special registers, arranged in an ID table ranging from 1-10:
<br></br>

| ID  | Short    |  Name                  | Function                  | Description |
| --- | -------- | ---------------------- | ------------------------- |-------------|
| 01  | A        | A Register             | General Purpose Register  | Stores basic data types, used to manipulate data.|
| 02  | B        | B Register             | General Purpose Register  |
| 03  | C        | C Register             | General Purpose Register  |
| 04  | D        | D Register             | General Purpose Register  |
| 05  | E        | E Register             | General Purpose Register  |
| 06  | F        | F Register             | General Purpose Register  |
| 07  | MAR      | Memory Access Register | Special Register          | Stores the pointer for the LOD and STO operations.|
| 08  | PC       | Program Counter        | Special Register          | Stores the current pointed instruction (in byte triplets) in memory.|
| 09  | SP       | Stack Pointer          | Special Register          | Points to the current stack address.|
| 09  | IR       | instruction Register   | Special Register          | Stores the current operation's instruction. |

# Flags
WOS88 features six processor status flags, arranged in an ID table ranging from 1-6:
<br></br>

| ID  | Short |  Name          | Function                                          |
| --- | ------| ---------------| --------------------------------------------------|
| 01  | ZF    | Zero Flag      | Raised if Target is 0.                            |
| 02  | OF    | Overflow Flag  | Raised if Target overflows.                       |
| 03  | EF    | Equal Flag     | Raised if Source is equal to Target.              |
| 04  | NF    | Negative Flag  | Raised if Target is negative.                     |
| 05  | 1     | Unknown        | Raised on startup, and is an undocumented feature.|
| 06  | IF    | Interrupt Flag | Used with YIR and HLI. Raised by hardware IRQ.    |
