// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

// SETUP

    @R2    // initialize result to 0
    M=0

(LOOP)     // we will add R0 to R2 recursively R1 times

    @R1    // If R1==0, exit - result is 0
    D=M
    @END
    D;JEQ
    @R0    // If R0==0, exit - result is 0
    D=M
    @END
    D;JEQ
    @R2    // with R0 still selected, add it to R2
    D=D+M
    M=D
    @R1    // substract 1 to R1
    M=M-1 
    D=M
    @END   // if R1==0, we are done
    D;JEQ
    @LOOP  // else, go back to loop
    0;JMP

(END)
    @END
    0;JMP
