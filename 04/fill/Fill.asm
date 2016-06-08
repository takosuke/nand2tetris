// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.


// TODO:
// eliminate the FULL loop?
//  break the FILL loop if keyboard input is interrupted half way 

// Setup

               // Create a variable for the number of screen memory registers 
    @8191      // 32*256 = 8192 screen memory registers to fill (-1 because zero indexed)
    D=A
    @numwords
    M=D

(LOOP)         // loop while waiting for keyboard input

    @i         // starting index for filling or emptying the screen
    M=0        // initialize to 0

    @KBD       // if the keyboard memory is not zero, jump to fill screen loop
    D=M
    @FILL
    D;JNE

    @LOOP      // else jump back to beginning of loop
    0;JMP

(FILL)         // screen fill loop

    @i         // select index (initialized to 0)
    D=M
    @SCREEN    // add index to screen memory base address
    A=A+D
    M=-1       // set it to 1111111111111111111 in binary (thus, all black)
    @i         // add 1 to index
    M=M+1
    @numwords  // check if index equals the number of screen memory locations
    D=D-M
    @FULL      // jump to full loop if it does
    D;JGT
    @FILL      // keep filling the screen otherwise
    0;JMP

(FULL)         // loop after screen is full

    @i         // set index back to zero
    M=0
    @KBD       // check if keyboard is not pressed (kbd memory == 0) 
    D=M
    @CLEAR     // jump to clear screen subroutine
    D;JEQ
    @FULL      // else stay in full loop
    0;JMP

(CLEAR)        // clear screen when key is depressed

    @i         // select index(initialized to 0 again)
    D=M
    @SCREEN    // select screen start address plus index
    A=A+D
    M=0        // set it to 0
    @i
    M=M+1      // increment index
    @numwords  // when index == number of screen memory locations
    D=D-M
    @LOOP      // go back to main loop
    D;JGT
    @CLEAR     // else keep clearing screen
    0;JMP
