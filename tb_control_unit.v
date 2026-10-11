`timescale 1ns / 1ps

module tb_control();
    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg        zero_flag, lt_flag, ltu_flag;

    wire       reg_write, alu_src, mem_write, pc_src, jalr, auipc;
    wire [1:0] result_src, alu_op;

    ControlUnit uut (
        .opcode(opcode),
        .funct3(funct3),
        .zero_flag(zero_flag),
        .lt_flag(lt_flag),
        .ltu_flag(ltu_flag),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .pc_src(pc_src),
        .jalr(jalr),
        .auipc(auipc),
        .alu_op(alu_op)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_control);

        // Test 1: R-Type Instruction
        opcode = 7'b0110011; funct3 = 3'b000; zero_flag = 0; lt_flag = 0; ltu_flag = 0; #10;

        // Test 2: BEQ Branch Taken (zero_flag = 1)
        opcode = 7'b1100011; funct3 = 3'b000; zero_flag = 1; #10;

        // Test 3: BLT Branch Taken (lt_flag = 1)
        funct3 = 3'b100; zero_flag = 0; lt_flag = 1; #10;

        $display("Control Unit Test Complete!");
        $finish;
    end
endmodule
