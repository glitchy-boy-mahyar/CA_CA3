`timescale 1 ns / 1 ns
`include "constant_values.h"

module alu_controller(alu_ctrl, func, alu_op);
    input [1:0] alu_ctrl;
    input [5:0] func;
    output reg [2:0] alu_op;

    always @(alu_ctrl or func) begin
        alu_op = `ALU_OFF;
        case(alu_ctrl)
            `ALU_CTRL_MTYPE: begin
                alu_op = `ALU_ADD;
                $display("@%t: ALU_CTRL::MTYPE", $time);
            end

            `ALU_CTRL_BTYPE: begin
                alu_op = `ALU_SUB;
                $display("@%t: ALU_CTRL::BTYPE", $time);
            end

            `ALU_CTRL_RTYPE: begin
                case(func)
                    `FUNC_ADD: begin
                        alu_op = `ALU_ADD;
                    end

                    `FUNC_SUB: begin
                        alu_op = `ALU_SUB;
                    end

                    `FUNC_AND: begin 
                        alu_op = `ALU_AND;
                    end

                    `FUNC_OR: begin
                        alu_op = `ALU_OR;
                    end

                    `FUNC_SLT: begin
                        alu_op = `ALU_SLT;
                    end

                    default: alu_op = `ALU_OFF; 
                endcase
                $display("@%t: ALU_CTRL::RTYPE: func = %d", $time, func);
            end

            `ALU_CTRL_JTYPE: begin
                alu_op = `ALU_OFF;
                $display("@%t: ALU_CTRL::JTYPE", $time);
            end

            default: alu_op = `ALU_OFF;
        endcase
    end
endmodule
