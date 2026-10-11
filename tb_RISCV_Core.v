// ============================================================================
// TESTBENCH FOR TOP-LEVEL RISC-V CORE
// File Name: tb_RISCV_Core.v
// ============================================================================

`timescale 1ns / 1ps

module tb_RISCV_Core();
    reg clk;
    reg reset;

    RISCV_Core uut (
        .clk(clk),
        .reset(reset)
    );

    // Generate 100MHz clock signal
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_RISCV_Core);

        clk   = 0;
        reset = 1;

        #10 reset = 0; // Release Reset

        #60; // Run simulation for 6 clock cycles

        // Display Execution Results
        $display("\n=======================================================");
        $display("          RISC-V SINGLE-CYCLE EXECUTION TEST           ");
        $display("=======================================================");
        $display("x1 (ADDI 20)    = %d  (Expected: 20)",  uut.RegFile.registers[1]);
        $display("x2 (ADDI 10)    = %d  (Expected: 10)",  uut.RegFile.registers[2]);
        $display("x3 (ADD 20+10)  = %d  (Expected: 30)",  uut.RegFile.registers[3]);
        $display("x4 (LW from Mem) = %d  (Expected: 30)",  uut.RegFile.registers[4]);
        $display("=======================================================\n");

        $finish;
    end
endmodule
