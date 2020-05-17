`timescale 1 ns / 1 ns
`include "constant_values.h"

module mux_32_bit(in_0, in_1, out, select);
    input [31:0] in_0, in_1;
    input select;
    output reg [31:0] out;

    always @(in_0, in_1, select) begin
        if (select == 1'b0)
            out = in_0;
        else if (select == 1'b1)
            out = in_1;
    end
endmodule

module mux_32bit_test();
    reg [31:0] in_0, in_1;
    reg select;
    wire [31:0] out;

    mux_32_bit mux_32_bit_test(in_0, in_1, out, select);
    initial begin
        in_0 = 32'b0000000000000000_0000000000000000;
        in_1 = 32'b1111111111111111_1111111111111111;
        select = 1'b0;
        #1000 select = 1'b1;
        #1000 in_1 = 32'b1010101010101010_1010101010101010;
        #1000 in_0 = 32'b0101010101010101_0101010101010101;
        select = 1'b0;
        #1000;
    end
endmodule