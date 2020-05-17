`include "constant_values.vh"
`timescale 1 ns / 1 ns
module controller(clk, rst, opcode, func, pc_write, pc_write_cond, IR_write, reg_dst, jal_reg, pc_to_reg, 
                 mem_to_reg, reg_write, alu_src_A, alu_src_B, alu_ctrl, ctrl_func, pc_src, I_or_D, mem_write, mem_read);

    input clk, rst;
    input [5:0] opcode, func;
    output reg pc_write, pc_write_cond, IR_write, reg_dst, jal_reg, pc_to_reg, 
                 mem_to_reg, reg_write, alu_src_A, pc_src, I_or_D, mem_write, mem_read;
    output reg [1:0] alu_src_B, alu_ctrl;
    output reg [5:0] ctrl_func;
    
    parameter IF = 4'b0000;
    parameter ID = 4'b0001;
    parameter BRANCH = 4'b0010;
    parameter JUMP = 4'b0011;
    parameter RTYPE_EXEC = 4'b0100;
    parameter RTYPE_COMPLETION = 4'b0101;
    parameter MEM_REF = 4'b0110;
    parameter LW_READ = 4'b0111;
    parameter LW_COMPLETION = 4'b1000;
    parameter SW = 4'b1001;
    parameter JAL = 4'b1010;
    parameter JR = 4'b1011;
    parameter IMMEDIATE_EXEC = 4'b1100;

    always @(opcode or func) begin
        if (opcode == `OPC_ANDI)
            ctrl_func = `FUNC_AND;
        else if (opcode == `OPC_ADDI)
            ctrl_func = `FUNC_ADD;
        else
            ctrl_func = func;        
    end

    reg [3:0] ps, ns;
    always @(ps) begin
        case(ps)
            IF: ns = ID;
            ID: begin
                if (opcode == `OPC_BEQ || opcode == `OPC_BNE)
                    ns = BRANCH;
                else if (opcode == `OPC_JUMP)
                    ns = JUMP;
                else if (opcode == `OPC_REGISTER_TYPE) begin
                    if (ctrl_func == `FUNC_JR)
                        ns = JR;
                    else
                        ns = RTYPE_EXEC;
                end
                else if (opcode == `OPC_LW || opcode == `OPC_SW)
                    ns = MEM_REF;
                else if (opcode == `OPC_ADDI || opcode == `OPC_ANDI)
                    ns = IMMEDIATE_EXEC;
            end
            BRANCH: ns = IF;
            JUMP: ns = IF;
            RTYPE_EXEC: ns = RTYPE_COMPLETION;
            RTYPE_COMPLETION: ns = IF;
            MEM_REF: begin
                if (opcode == `OPC_LW)
                    ns = LW_READ;
                else if (opcode == `OPC_SW)
                    ns = SW;
            end
            
            LW_READ: ns = LW_COMPLETION;
            LW_COMPLETION: ns = IF;
            SW: ns = IF;
            JAL: ns = IF;
            JR: ns = IF;
            IMMEDIATE_EXEC: ns = RTYPE_COMPLETION;
            default: ns = IF;            
        endcase    
    end

    always @(ps) begin
        {pc_write, pc_write_cond, IR_write, reg_dst, jal_reg, pc_to_reg, 
                 mem_to_reg, reg_write, alu_src_A, alu_src_B, pc_src, I_or_D, mem_write, mem_read} = 14'b0000000_0000000;
        alu_ctrl = 2'bzz;
        
        case(ps)
            IF: begin
                mem_read = 1'b1;
                IR_write = 1'b1;
                alu_src_B = 2'b01;
                pc_write = 1'b1;
                alu_ctrl = `ALU_CTRL_MTYPE;
            end

            ID: begin
                alu_src_B = 2'b11;
                alu_ctrl = `ALU_CTRL_MTYPE;
            end

            BRANCH: begin
                pc_src = 2'b11;
                pc_write_cond = 1'b1;
                alu_src_A = 1'b1;
                alu_ctrl = `ALU_CTRL_BTYPE;
            end

            JUMP: begin
                pc_write = 1'b1;
                pc_src = 2'b01;
                alu_ctrl = `ALU_CTRL_JTYPE;
            end

            RTYPE_EXEC: begin
                alu_src_A = 1'b1;
                alu_ctrl = `ALU_CTRL_RTYPE;
            end

            RTYPE_COMPLETION: begin
                reg_dst = 1'b1;
                reg_write = 1'b1;
            end

            MEM_REF: begin
                alu_src_A = 1'b1;
                alu_src_B = 2'b10;
                alu_ctrl = `ALU_CTRL_MTYPE;
            end

            LW_READ: begin
                mem_read = 1'b1;
                I_or_D = 1'b1;
            end

            LW_COMPLETION: begin
                reg_dst = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
            end

            SW: begin
                mem_write = 1'b1;
                I_or_D = 1'b1;
            end

            JAL: begin
                reg_dst = 1'b1;
                jal_reg = 1'b1;
                reg_write = 1'b1;
                pc_src = 2'b01;
                pc_write = 1'b1;
            end

            JR: begin
                pc_write = 1'b1;
                pc_src = 2'b10;
            end

            IMMEDIATE_EXEC: begin
                alu_src_A = 1'b1;
                alu_src_B = 2'b10;
                alu_ctrl = `ALU_CTRL_RTYPE;
            end
        
        endcase
    end
    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1)
            ps <= IF;
        else
            ps <= ns;
    end
endmodule
