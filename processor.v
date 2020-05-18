`timescale 1 ns / 1 ns
module processor(clk , rst);
    input clk , rst;

    wire ZERO;
    wire pc_write , IR_write , reg_dst , jal_reg , pc_to_reg , mem_to_reg , reg_write,
            alu_src_A , I_or_D , mem_write , mem_read;

    wire [5:0] opcode , func;
    wire [1:0] alu_src_B , pc_src;
    wire [2:0] alu_op;

    data_path dp(clk, rst, pc_write, IR_write, reg_dst , jal_reg, pc_to_reg, 
                 mem_to_reg, reg_write, alu_src_A, alu_src_B, alu_op, pc_src, 
                 I_or_D, mem_write, mem_read, ZERO, opcode, func);

    controller c(clk, rst, ZERO, opcode, func, pc_write, IR_write, reg_dst, jal_reg, pc_to_reg, 
                 mem_to_reg, reg_write, alu_src_A, alu_src_B, pc_src, I_or_D, mem_write, mem_read , alu_op);
endmodule


module processor_test();
    reg clk, rst;
    processor mips(clk, rst);

    initial begin
        clk = 1'b1;
        repeat(2000) #50 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #50 rst = 1'b0;
        #80000 $stop; // it is for testbench no.2

        // #24300 $stop; // it is for testbench no.1
        
    end
endmodule
