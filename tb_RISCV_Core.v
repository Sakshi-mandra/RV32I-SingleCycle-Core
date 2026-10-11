`timescale 1ns / 1ps

module tb_RISCV_Core();
    reg clk;
    reg reset;

    RISCV_Core uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_RISCV_Core);

        clk   = 0;
        reset = 1;

        #10 reset = 0; // Release Reset

        #80; // Run simulation for 8 clock cycles

        $display("\n=======================================================");
        $display("       ADVANCED SB / LBU / BLT / SUB TEST RESULTS      ");
        $display("=======================================================");
        $display("x1 (ADDI 5)       = %d  (Expected: 5)",   uut.RegFile.registers[1]);
        $display("x2 (ADDI 15)      = %d  (Expected: 15)",  uut.RegFile.registers[2]);
        $display("x3 (LBU from Mem) = %d  (Expected: 15)",  uut.RegFile.registers[3]);
        $display("x4 (Skipped ADDI) = %d  (Expected: 0)",   uut.RegFile.registers[4]);
        $display("x5 (SUB 15-5)     = %d  (Expected: 10)",  uut.RegFile.registers[5]);
        $display("=======================================================\n");

        $finish;
    end
endmodule