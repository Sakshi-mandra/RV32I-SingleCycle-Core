`timescale 1ns / 1ps

module tb_immgen();
    reg  [31:0] instr;
    wire [31:0] imm_ext;

    ImmGen uut (
        .instr(instr),
        .imm_ext(imm_ext)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_immgen);

        // Test 1: I-Type -> ADDI x3, x0, 15 (0x00f00193) -> Expect 15
        instr = 32'h00f00193; #10;

        // Test 2: I-Type Negative -> ADDI x4, x0, -5 (0xfff00213) -> Expect -5 (0xFFFFFFFB)
        instr = 32'hfff00213; #10;

        // Test 3: U-Type -> LUI x1, 0x12345 (0x123450b7) -> Expect 0x12345000
        instr = 32'h123450b7; #10;

        // Test 4: S-Type -> SW x7, 4(x0) (0x00702223) -> Expect 4
        instr = 32'h00702223; #10;

        // Test 5: J-Type -> JAL x18, +8 (0x0080096f) -> Expect 8
        instr = 32'h0080096f; #10;

        $display("Immediate Generator Test Complete!");
        $finish;
    end
endmodule
