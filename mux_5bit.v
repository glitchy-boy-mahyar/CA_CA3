module mux_5_bit(in_0, in_1, out, select);
    input [4:0] in_0, in_1;
    input select;
    output reg [4:0] out;

    always @(in_0, in_1, select) begin
        if (select == 1'b0)
            out = in_0;
        else if (select == 1'b1)
            out = in_1;
    end
endmodule

module mux_5bit_test();
    reg [4:0] in_0, in_1;
    reg select;
    wire [4:0] out;

    mux_5_bit mux_5_bit_test(in_0, in_1, out, select);
    initial begin
        in_0 = 5'b00000;
        in_1 = 5'b11111;
        select = 1'b0;
        #1000 select = 1'b1;
        #1000 in_1 = 5'b10101;
        #1000 in_0 = 5'b01010;
        select = 1'b0;
        #1000;
    end
endmodule