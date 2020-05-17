`timescale 1 ns / 1 ns
`include "constant_values.vh"

module register_file(read_reg1, read_reg2, write_reg, write_data,
                        reg_write, read_data1, read_data2 , clk);

    input [4:0] read_reg1, read_reg2, write_reg;
    input [31:0] write_data;
    output reg [31:0] read_data1 , read_data2;
    input reg_write;
    input clk;

    reg [31:0] registers [31:0];

    // reading registers from file
    initial begin
		$readmemb("registers.bin", registers);
	end

    always @(read_reg1 or read_reg2 or registers[read_reg1] or registers[read_reg2]) begin
		read_data1 = registers[read_reg1];
		read_data2 = registers[read_reg2];
        $display("@%t: REG_FILE::READ: registers %d = %d, %d = %d are read", $time, read_reg1, read_data1,
                read_reg2, read_data2);
	end

    always @(posedge clk) begin
        if(reg_write == 1'b1) begin
            registers[write_reg] <= write_data;
            $display("@%t: REG_FILE::WRITE: value %d stored in register %d", $time, write_data, write_reg);
        end
    end
endmodule

module reg_file_test();
    reg [4:0] read_reg1, read_reg2 , write_reg;
    reg [31:0] write_data;
    wire [31:0] read_data1 , read_data2;
    reg reg_write;
    reg clk;

    register_file reg_file_test(read_reg1, read_reg2, write_reg, write_data,
                        reg_write, read_data1, read_data2 , clk);
    
    initial begin
        clk = 1'b1;
        repeat(200) #50 clk = ~clk;
    end

    initial begin
        read_reg1 = 5'b00000;
        read_reg2 = 5'b00000;
        write_reg = 5'b00001;
        write_data = 32'b0000000000000000_1111111111111111;
        reg_write = 1'b1;
        #100 reg_write = 1'b0;
        #1000 read_reg1 = 5'b00001;
        #1000 write_reg = 5'b11110;
        write_data = 32'b1111111111111111_0000000000000000;
        reg_write = 1'b1;
        #500 reg_write = 1'b0;
        write_data = `WORD_ZERO;
        read_reg2 = 5'b11110;
        #1000 read_reg1 = 5'b11110;
        #1000 read_reg2 = 5'b00001;
        #1000;
    end

endmodule