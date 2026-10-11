module InstructionMemory (
    input  wire [31:0] addr,
    output wire [31:0] instr
);
    reg [31:0] mem [0:63];

    // Declare variable outside the initial block for standard Verilog compliance
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h0000_0000;

        $readmemh("instructions.mem", mem);
    end

    assign instr = mem[addr[31:2]];
endmodule
