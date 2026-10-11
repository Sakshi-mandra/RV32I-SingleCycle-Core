module DataMemory (
    input  wire        clk,
    input  wire        mem_write,
    input  wire [3:0]  byte_enable,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [7:0] mem [0:255]; // 256 bytes

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 8'h00;
    end

    wire [31:0] base_addr = {addr[31:2], 2'b00};

    // Combinational Read
    assign read_data = {mem[base_addr + 3], mem[base_addr + 2], mem[base_addr + 1], mem[base_addr]};

    // Synchronous Byte-Selectable Write
    always @(posedge clk) begin
        if (mem_write) begin
            if (byte_enable[0]) mem[base_addr + 0] <= write_data[7:0];
            if (byte_enable[1]) mem[base_addr + 1] <= write_data[15:8];
            if (byte_enable[2]) mem[base_addr + 2] <= write_data[23:16];
            if (byte_enable[3]) mem[base_addr + 3] <= write_data[31:24];
        end
    end
endmodule
