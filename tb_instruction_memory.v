`timescale 1ns / 1ps

module tb_instruction_memory();
    reg  [31:0] addr;
    wire [31:0] instr;

    // Instantiate Instruction Memory
    InstructionMemory uut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        // Setup waveform dump for Surfer
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_instruction_memory);

        // Pre-load dummy instruction hex values into memory for testing
        uut.mem[0] = 32'h123450b7; // PC = 0x0
        uut.mem[1] = 32'h00001117; // PC = 0x4
        uut.mem[2] = 32'h00f00193; // PC = 0x8
        uut.mem[3] = 32'h004182b3; // PC = 0x12 (0xC)

        // Read PC = 0x0 (Word index 0)
        addr = 32'h0000_0000; #10;
        
        // Read PC = 0x4 (Word index 1)
        addr = 32'h0000_0004; #10;

        // Read PC = 0x8 (Word index 2)
        addr = 32'h0000_0008; #10;

        // Read PC = 0xC (Word index 3)
        addr = 32'h0000_000C; #10;

        $display("Instruction Memory Test Complete!");
        $finish;
    end
endmodule

