module RegisterFile (
    input  wire        clk,
    input  wire        reg_write,
    input  wire [4:0]  rs1,        // Source Register 1 Address
    input  wire [4:0]  rs2,        // Source Register 2 Address
    input  wire [4:0]  rd,         // Destination Register Address
    input  wire [31:0] write_data, // Data to write into rd
    output wire [31:0] read_data1, // Data read from rs1
    output wire [31:0] read_data2  // Data read from rs2
);
    reg [31:0] registers [0:31];
    integer i;

    // Initialize all registers to 0
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'h0000_0000;
    end

    // x0 is hardwired to zero
    assign read_data1 = (rs1 == 5'b0) ? 32'h0000_0000 : registers[rs1];
    assign read_data2 = (rs2 == 5'b0) ? 32'h0000_0000 : registers[rs2];

    // Synchronous Write
    always @(posedge clk) begin
        if (reg_write && (rd != 5'b0)) begin
            registers[rd] <= write_data;
        end
    end
endmodule
