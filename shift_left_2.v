`timescale 1 ns / 1 ns
module shift_left_2(sign_extended_address , shifted_address);

    output reg [31:0] shifted_address;
    input [31:0] sign_extended_address;

    always @(sign_extended_address)begin
      shifted_address = sign_extended_address << 2;
    end
endmodule


