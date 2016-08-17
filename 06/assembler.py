#!/usr/bin/env python
import sys


jmp_table = {
        'null': '000',
        'JGT': '001',
        'JEQ': '010',
        'JGE': '011',
        'JLT': '100',
        'JNE': '101',
        'JLE': '110',
        'JMP': '111'
        } 

comp_table = {
        '0':  '0101010',
        '1':  '0111111',
        '-1': '0111010',
        'D':  '0001100',
        'A':  '0110000',
        '!D': '0001101',
        '!A': '0110001',
        '-D': '0001111',
        '-A': '0110011',
        'D+1':'0011111',
        'A+1':'0110111',
        'D-1':'0001110',
        'A-1':'0110010',
        'D+A':'0000010',
        'D-1':'0010011',
        'A-D':'0000111',
        'D&A':'0000000',
        'D|A':'0010101',
        'M':  '1110000',
        '!M': '1110001',
        '-M': '1110011',
        'M+1':'1110111',
        'M-1':'1110010',
        'D+M':'1000010',
        'D-M':'1010011',
        'M-D':'1000111',
        'D&M':'1000000',
        'D|M':'1010101'
        }

dest_table = {
        'null': '000',
        'M':    '001',
        'D':    '010',
        'MD':   '011',
        'A':    '100',
        'AM':   '101',
        'AD':   '110',
        'AMD':  '111'
        }

symbols = {
        'R0': 0,
        'R1': 1,
        'R2': 2,
        'R3': 3,
        'R4': 4,
        'R5': 5,
        'R6': 6,
        'R7': 7,
        'R8': 8,
        'R9': 9,
        'R10': 10,
        'R11': 11,
        'R12': 12,
        'R13': 13,
        'R14': 14,
        'R15': 15,
        'SCREEN': 16384,
        'KBD': 24576,
        'SP': 0,
        'LCL': 1,
        'ARG': 2,
        'THIS': 3,
        'THAT': 4
        }

mem_counter = 16

labels = {}

def handle_labels(asm_lines):
    """Gets labels, puts them in symbol tables and removes
    them from original asm_lines list with side effects!"""
    for index, line in enumerate(asm_lines):
        if line.startswith('('):
            label = line.strip('()')
            symbols[label] = index
            asm_lines.pop(index)


def prep_file(file):
    asm_lines = file.split('\r\n')
    asm_lines = [line.split('//')[0].strip() for line in asm_lines if line and line[:2] != '//']
    handle_labels(asm_lines)
    return asm_lines

def handle_A_instruction(instruction):
    try:
        int(instruction)
    except ValueError:
        if instruction in symbols:
            instruction = "@%d" %(symbols[instruction.split('@')[1]])
        else:
            global mem_counter
            symbols[instruction] = mem_counter
            mem_counter += 1
            instruction = "@%d" %(symbols[instruction.split('@')[1]])

    address = int(instruction.split('@')[1])
    instruction = "0" + format(address, "015b")
    return instruction

def handle_C_instruction(instruction):
    if ';' not in instruction:
        jmp = '000'
    else:
        instruction, jmp = instruction.split(';')
        jmp = jmp_table[jmp]
        
    if '=' not in instruction:
        dest = '000'
    else:
        dest, instruction = instruction.split('=')
        dest = dest_table[dest]

    comp = comp_table[instruction]

    bin_instruction = '111%s%s%s' %(comp, dest, jmp)

    return bin_instruction

def main_instruction_handler(file):
    asm_lines = prep_file(file)
    machine_code = []
    print symbols['R0']
    for instruction in asm_lines:
        if instruction.startswith('@'):
            machine_code.append(handle_A_instruction(instruction))
        else:
            machine_code.append(handle_C_instruction(instruction))

    machine_code = '\n'.join(machine_code)
    return machine_code

def main():
    with open(sys.argv[1], 'r') as f:
        asm_file = f.read()

    machine_code = main_instruction_handler(asm_file)
    with open(sys.argv[2], 'w') as outf:
        outf.write(machine_code)


if __name__ == '__main__':
    main()




    
