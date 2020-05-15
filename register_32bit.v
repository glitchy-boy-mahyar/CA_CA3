module register_32bit(in , out , clk);
    input [31:0] in;
    output reg [31:0] out;
    input clk;
    always @(posedge clk)begin
      out <= in;
    end
endmodule