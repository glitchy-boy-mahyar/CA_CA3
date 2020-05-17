`timescale 1 ns / 1 ns
module pc_controller(pc_write, zero, pc_write_cond, pc_ctrl_out);
    input pc_write, zero, pc_write_cond;
    output pc_ctrl_out;

    assign pc_ctrl_out = pc_write | (zero & pc_write_cond);
endmodule