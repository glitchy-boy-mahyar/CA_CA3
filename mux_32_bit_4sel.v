module mux_32_bit_4sel(in_0, in_1 , in_2 , in_3, out, select);
    input [31:0] in_0, in_1 , in_2 , in_3;
    input select;
    output reg [31:0] out;

    always @(in_0, in_1, select) begin
        if (select == 2'b00)
            out = in_0;
        else if (select == 2'b01)
            out = in_1;
        else if (select == 2'b10)
            out = in_2;
        else if (select == 2'b11)
            out = in_3;        
    end
endmodule