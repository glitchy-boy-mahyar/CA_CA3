`timescale 1 ns / 1 ns
`include "constant_values.h"

module data_path(clk, rst, pc_write, IR_write, reg_dst , jal_reg, pc_to_reg, 
                 mem_to_reg, reg_write, alu_src_A, alu_src_B, alu_op, pc_src, 
                 I_or_D, mem_write, mem_read, ZERO, opcode, func);

    inout clk , rst;
    input pc_write, IR_write, reg_dst, jal_reg, pc_to_reg, mem_to_reg, reg_write,  
            alu_src_A, I_or_D, mem_write, mem_read;
    input [1:0] pc_src, alu_src_B;
    input [2:0] alu_op;
    output reg ZERO;
    output reg [5:0] opcode, func;


    wire [31:0] pc_out, pc_src_out, I_or_D_out, A_out, B_out, data_mem_out, IR_out, MDR_out, 
                pc_to_reg_out, read_reg_1, read_reg_2, sign_ext_out, shift_left_2_out, shifter_for_jump_out,
                alu_out, AluOut_out , mem_to_reg_out , alu_src_A_out , alu_src_B_out;


    wire [4:0] jal_reg_out, reg_dst_out;

    pc program_counter(pc_src_out, pc_out, pc_write, clk, rst);

    data_mem memory(I_or_D_out, B_out, data_mem_out, mem_read, mem_write);

    IR_register IR(data_mem_out, IR_out, IR_write, clk);

    register_32bit MDR(data_mem_out, MDR_out, clk);

    registe_file reg_file(IR_out[25:21] , IR_out[20:16] , jal_reg_out , pc_to_reg_out , reg_write , read_reg_1 , read_reg_2 , clk);

    register_32bit A(read_reg_1 , A_out , clk);
    register_32bit B(read_reg_2 , B_out , clk);

    sign_ext_16_to_32 sign_extension(IR_out[15:0] , sign_ext_out);

    shift_left_2 shlf2(sign_ext_out , shift_left_2_out);

    shifter_for_jump shfj(IR_out , pc_out , shifter_for_jump_out);

    alu alu_unit(alu_src_A_out , alu_src_B_out , alu_out , ZERO , alu_op);

    register_32bit AluOut(alu_out, AluOut_out, clk);
    
    mux_32_bit mux_I_or_D(pc_out , AluOut_out , I_or_D_out , I_or_D);

    mux_5bit mux_reg_dst(IR_out[20:16] , IR_out[15:11] , reg_dst_out , reg_dst);
    mux_5bit mux_jal_reg(reg_dst_out , `THIRTY_ONE , jal_reg_out , jal_reg);

    mux_32_bit mux_mem_to_reg(AluOut_out , MDR_out , mem_to_reg_out , mem_to_reg);
    mux_32_bit mux_pc_to_reg(mem_to_reg_out , pc_out , pc_to_reg_out , pc_to_reg);
    mux_32_bit mux_alu_src_A(pc_out, A_out, alu_src_A_out, alu_src_A);

    mux_32_bit_4sel mux_alu_src_B(B_out, `FOUR, sign_ext_out, shift_left_2_out, alu_src_B_out, alu_src_B);
    mux_32_bit_4sel mux_pc_src(alu_out, shifter_for_jump_out, A_out, AluOut_out, pc_src_out, pc_src);

    always @(IR_out) begin
        opcode = IR_out[31:26];
        func = IR_out[5:0];
    end

endmodule