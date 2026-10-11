`timescale 1ns / 1ps

module tb_pc();
    reg         clk;
    reg         reset;
    reg  [31:0] pc_in;
    wire [31:0] pc_out;

    // Instantiate Program Counter
    ProgramCounter uut (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Clock Generation (10ns clock period)
    always #5 clk = ~clk;

    initial begin
        // Setup waveform dumping for Surfer
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_pc);

        // Initialize signals
        clk   = 0;
        reset = 1;
        pc_in = 32'h0000_0000;

        // Apply Reset
        #10;
        reset = 0;

        // Test PC updates
        pc_in = 32'h0000_0004; #10;
        pc_in = 32'h0000_0008; #10;
        pc_in = 32'h0000_000C; #10;
        pc_in = 32'h0000_0010; #10;

        // Test Reset again
        reset = 1; #10;
        reset = 0; #10;

        $display("PC Test Complete!");
        $finish;
    end
endmodule
