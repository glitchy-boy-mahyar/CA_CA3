`timescale 1 ns / 1 ns
module pc_controller(pc_write, ZERO, pc_write_cond, pc_ctrl_out);
    input pc_write, ZERO, pc_write_cond;
    output reg pc_ctrl_out;

    always @(pc_write_cond or pc_write or ZERO) begin
        pc_ctrl_out = pc_write | (pc_write_cond & ZERO);
    end
endmodule