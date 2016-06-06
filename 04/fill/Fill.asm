// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.
//    @32
//    D=A
//    @columns
//    M=D
//    @16
//    D=A
//    @rows
//    M=D
    @8190
    D=A
    @numwords
    M=D
    @i
    M=0
//    @j
//    M=0

(LOOP)

    @i
    M=0
    @KBD
    D=M
    @FILL
    D;JGT
    @LOOP
    0;JMP

(FILL)


    @i
    D=M
    @SCREEN
    A=A+D
    M=-1
    @i
    M=M+1
    @numwords
    D=D-M
    @FULL
    D;JGT
    @FILL
    0;JMP

(FULL)

    @i
    M=0
    @KBD
    D=M
    @CLEAR
    D;JEQ
    @FULL
    0;JMP

(CLEAR)

    @i
    D=M
    @SCREEN
    A=A+D
    M=0
    @i
    M=M+1
    @numwords
    D=D-M
    @LOOP
    D;JGT
    @CLEAR
    0;JMP
