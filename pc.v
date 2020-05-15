`timescale 1 ns / 1 ns
`include "constant_values.h"
module pc(in, out, clk , rst);
    input [31:0] in;
    output reg [31:0] out;
    input clk , rst;

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            out <= `WORD_ZERO;
            $display("@%t: PC::RESET; PC is now 0", $time);
        end
        else begin
            out <= in;
            $display("@%t: PC is now %d", $time, in);
        end
    end

endmodule





module pc_test();
    reg [31:0] in;
    wire [31:0] out;
    reg clk, rst;

    pc pc_test(in, out, clk, rst);

    initial begin
        clk = 1'b1;
        repeat(200) #50 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #450 rst = 1'b0;
        in = 32'b0000111100001111_0000111100001111;
        #400 in = 32'b0101010101010101_0101010101010101;
        #850 in = 32'b0110011001100110_0110011001100110;
        #1000; 
    end

endmodule
