// constant values to be used globally
// in this project

`ifndef __CONST_H__
`define __CONST_H__

`define WORD_ZERO 32'b0000000000000000_0000000000000000
`define WORD_ONE 32'b0000000000000000_0000000000000001

`define Z 32'bzzzzzzzzzzzzzzzz_zzzzzzzzzzzzzzzz
`define THIRTY_ONE 5'b11111
`define FOUR 32'b0000000000000000_0000000000000100

// alu operation input
`define ALU_AND 3'b000
`define ALU_OR 3'b001
`define ALU_ADD 3'b010
`define ALU_SUB 3'b011
`define ALU_SLT 3'b100
`define ALU_OFF 3'b110

// alu controller input

`define ALU_CTRL_MTYPE 2'b00 // memory access
`define ALU_CTRL_BTYPE 2'b01 // branch
`define ALU_CTRL_RTYPE 2'b10 // register
`define ALU_CTRL_JTYPE 2'b11 // jump

`define FUNC_ADD 6'b100000
`define FUNC_SUB 6'b100010
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_SLT 6'b101010
`define FUNC_JR 6'b001000

// opcodes
`define OPC_REGISTER_TYPE 6'b000000
`define OPC_LW 6'b100011
`define OPC_SW 6'b101011
`define OPC_BEQ 6'b000100
`define OPC_BNE 6'b000101
`define OPC_JUMP 6'b000010
`define OPC_JAL 6'b000011
`define OPC_ADDI 6'b001000
`define OPC_ANDI 6'b001100

`endif