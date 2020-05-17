`timescale 1 ns / 1 ns
`include "constant_values.h"

module data_mem(address, write_data, read_data, 
		mem_read, mem_write, clk);
	
	input [31:0] address;
	input [31:0] write_data;
	output reg [31:0] read_data;
	input mem_read, mem_write;
	input clk;
	
	reg [7:0] mem[0:2 ** 16 - 1];

	initial begin
		$readmemb("test_1_data_mem.bin", mem); // it is for testbench no.1
		// $readmemb("test_2_data_mem.bin", mem); // it is for testbench no.2
	end
	
	always @(posedge clk) begin
		if (mem_write == 1'b1) begin
			{mem[address[15:0]], mem[address[15:0] + 1], 
					mem[address[15:0] + 2], mem[address[15:0] + 3]} <= write_data;
			$display("@%t: DATA_MEM::WRITE: value %d stored at address %d", $time, write_data, address[15:0]);
		end
	end

	always @(mem_read or address) begin
		if (mem_read == 1'b1) begin
			read_data = {mem[address[15:0]], mem[address[15:0] + 1], 
					mem[address[15:0] + 2], mem[address[15:0] + 3]};
			$display("@%t: DATA_MEM::READ: value %d at address %d is read", $time, {mem[address[15:0]], mem[address[15:0] + 1], 
					mem[address[15:0] + 2], mem[address[15:0] + 3]}, address[15:0]);
		end
		else
			read_data = `Z;
	end

endmodule




module data_mem_test();
	reg [31:0] address, write_data;
	wire [31:0] read_data;
	reg mem_read, mem_write, clk;
	data_mem data_mem_test(address, write_data, read_data, mem_read, mem_write, clk);

	initial begin
		clk = 1'b1;
		repeat(200) #50 clk = ~clk;
	end

	initial begin
		mem_read = 1'b0;
		address = 32'b0000000000000000_0000000000000100;
		#100 write_data = 32'b0000000000000000_1111111111111111;
		mem_write = 1'b1;
		#100 write_data = `WORD_ZERO;
		mem_write = 1'b0;
		address = `WORD_ZERO;

		#1000 address = 32'b0000000000000000_0000000000000100;
		mem_read = 1'b1;
		#1000 mem_read = 1'b0;
		#500 address = 32'b0000000000000000_0000000000101100;
		mem_write = 1'b1;
		write_data = 32'b1111111111111111_0000000000000000;
		#100 mem_write = 1'b0;
		address = `WORD_ZERO;
		#1000 address = 32'b0000000000000000_0000000000101100;
		mem_read = 1'b1;
		#1450 address = 32'b0000000000000000_0000000000001100;
	end
endmodule

module data_mem_test_2();
	reg [31:0] address, write_data;
	wire [31:0] read_data;
	reg mem_read, mem_write, clk;
	data_mem data_mem_test_2(address, write_data, read_data, mem_read, mem_write, clk);

	initial begin
		clk = 1'b1;
		repeat(1000) #50 clk = ~clk;
	end

	integer i;
	initial begin
		mem_read = 1'b1;
		address = `WORD_ZERO;
		for (i = 1000; i < 1000 + 4 * 10; i = i + 4)
			#500 address = i;
	end
endmodule
