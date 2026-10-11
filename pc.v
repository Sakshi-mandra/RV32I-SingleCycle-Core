module ProgramCounter ( //declaring io ports
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc_in, // 32 bit input
    output reg  [31:0] pc_out // 32 bit output
);
    always @(posedge clk or posedge reset) //as a PC is a register that hold the address for the next instruction that triggers at +ve or -ve edge of the clock
    begin
        if (reset)
            pc_out <= 32'h0000_0000; // if reset is assertive(logic high) assign 32 bit hex
        else
            pc_out <= pc_in; // otherwise PC_in
    end
endmodule
