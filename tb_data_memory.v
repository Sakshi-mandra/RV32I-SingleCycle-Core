`timescale 1ns / 1ps

module tb_data_mem();
    reg         clk;
    reg         mem_write;
    reg  [2:0]  funct3;
    reg  [31:0] addr;
    reg  [31:0] reg_data_2;

    wire [31:0] raw_read_data;
    wire [31:0] formatted_read_data;
    wire [31:0] formatted_write_data;
    wire [3:0]  byte_enable;

    LoadStoreUnit lsu (
        .funct3(funct3),
        .addr_offset(addr[1:0]),
        .raw_read_data(raw_read_data),
        .reg_data_2(reg_data_2),
        .formatted_read_data(formatted_read_data),
        .formatted_write_data(formatted_write_data),
        .byte_enable(byte_enable)
    );

    DataMemory dmem (
        .clk(clk),
        .mem_write(mem_write),
        .byte_enable(byte_enable),
        .addr(addr),
        .write_data(formatted_write_data),
        .read_data(raw_read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_data_mem);

        clk       = 0;
        mem_write = 0;
        funct3    = 3'b010; // SW / LW
        addr      = 32'h0000_0000;
        reg_data_2 = 32'h1234_5678;

        #10;
        // Test 1: Store Word (SW)
        mem_write = 1;
        #10;

        // Test 2: Read Word (LW)
        mem_write = 0;
        #10;

        // Test 3: Store Byte (SB) at offset 2
        funct3     = 3'b000; // SB
        addr       = 32'h0000_0002;
        reg_data_2 = 32'h0000_00FF;
        mem_write  = 1;
        #10;

        // Test 4: Read Unsigned Byte (LBU) at offset 2
        funct3    = 3'b100; // LBU
        mem_write = 0;
        #10;

        $display("Data Memory & LSU Test Complete!");
        $finish;
    end
endmodule
