`timescale 1ns / 1ps

module tb_alu();
    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  alu_control;
    wire [31:0] result;
    wire        zero;
    wire        less_than;
    wire        less_than_u;

    ALU uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero),
        .less_than(less_than),
        .less_than_u(less_than_u)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_alu);

        // Test 1: ADD (15 + 10 = 25)
        a = 15; b = 10; alu_control = 4'b0000; #10;

        // Test 2: SUB (15 - 15 = 0, Zero Flag = 1)
        a = 15; b = 15; alu_control = 4'b0001; #10;

        // Test 3: SLL (15 << 2 = 60)
        a = 15; b = 2; alu_control = 4'b0010; #10;

        // Test 4: SLT Signed (-5 < 10 -> Result = 1)
        a = -5; b = 10; alu_control = 4'b0011; #10;

        // Test 5: SRA Shift Right Arithmetic (-8 >>> 1 = -4)
        a = -8; b = 1; alu_control = 4'b0111; #10;

        // Test 6: Bitwise AND (7 & 4 = 4)
        a = 7; b = 4; alu_control = 4'b1001; #10;

        $display("ALU Test Complete!");
        $finish;
    end
endmodule
