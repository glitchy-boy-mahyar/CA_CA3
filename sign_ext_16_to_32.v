`timescale 1 ns / 1 ns
module sign_ext_16_to_32(in, out);
    input [15:0] in;
    output reg [31:0] out;
    always @(in) begin
        out = { {16{in[15]}}, in};
    end

endmodule

module sign_ext_test();
    reg [15:0] in;
    wire [31:0] out;

    sign_ext_16_to_32 sign_ext_test(in, out);

    initial begin
        in = 16'b00001111_11111111;
        #1000 in = 16'b10001111_11111111;
        #1000;
    end

endmodule