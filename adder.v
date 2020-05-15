module adder(a, b, result);
    input [31:0] a, b;
    output reg [31:0] result;

    always @(a or b) begin
        result = a + b;
    end

endmodule