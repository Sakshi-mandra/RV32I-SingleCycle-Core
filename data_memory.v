module DataMemory (
    input  wire        clk,
    input  wire        mem_write,
    input  wire [3:0]  byte_enable,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] RAM [0:63];

    // Initialize all RAM entries to zero to prevent 'xx' uninitialized states
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1)
            RAM[i] = 32'h0000_0000;
    end

    // Memory Write (Synchronous with Byte Enable Masking)
    always @(posedge clk) begin
        if (mem_write) begin
            if (byte_enable[0]) RAM[addr[31:2]][7:0]   <= write_data[7:0];
            if (byte_enable[1]) RAM[addr[31:2]][15:8]  <= write_data[15:8];
            if (byte_enable[2]) RAM[addr[31:2]][23:16] <= write_data[23:16];
            if (byte_enable[3]) RAM[addr[31:2]][31:24] <= write_data[31:24];
        end
    end

    // Memory Read (Combinational)
    assign read_data = RAM[addr[31:2]];

endmodule
