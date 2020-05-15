`timescale 1 ns / 1 ns
`include "constant_values.h"

module data_path(clk , rst , pc_write , IRwrite , reg_dst , jal_rej , pc_to_reg , 
                 mem_to_reg , reg_write  , AluSrcA , AluSrcB , AluOp , pc_src , IorD , mem_write , mem_read , ZERO , opcode , func);

    inout clk , rst;
    input pc_write , IRwrite , reg_dst , jal_rej , pc_to_reg , mem_to_reg , reg_write ,  
            AluSrcA , IorD , mem_write , mem_read;
    input [2:0] pc_src;
    input [3:0] AluSrcB;
    input [2:0] AluOp;
    output reg ZERO;
    output reg [5:0] opcode ,func;


    wire [31:0] pc_out , pc_src_out , IorD_out , B_out ,data_mem_out

    pc program_counter(pc_src_out , pc_out , pc_write , clk , rst);
    data_mem memory(IorD_out , B_out , data_mem_out , mem_read , mem_write);
    IR_register IR();
    register_32bit MDR();
    registe_file reg_file();
    register_32bit A();
    register_32bit B();
    sign_ext_16_to_32 sign_extension();
    shift_left_2 shlf2();
    shifter_for_jump shfj();
    alu alu_unit();
    register_32bit AluOut();
    
    mux_32_bit mux_IorD();
    mux_5bit mux_reg_dst();
    mux_5bit mux_jal_reg();
    mux_32_bit mux_mem_to_reg();
    mux_32_bit mux_pc_to_reg();
    mux_32_bit mux_AluSrcA();
    mux_32_bit_4sel mux_AluSrcB();
    mux_32_bit_4sel mux_pc_src();



    
