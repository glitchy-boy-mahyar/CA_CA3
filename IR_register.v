module IR_register(in , out , load , clk);
    input [31:0] in ;
    input load , clk;
    output reg [31:0] out;

    always @(posedge clk)begin
        if(load)begin
            out <= in;
        end
    end
endmodule