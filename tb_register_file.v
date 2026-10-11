`timescale 1ns / 1ps

module tb_regfile();
    reg         clk;
    reg         reg_write;
    reg  [4:0]  rs1;
    reg  [4:0]  rs2;
    reg  [4:0]  rd;
    reg  [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    RegisterFile uut (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_regfile);

        clk        = 0;
        reg_write  = 0;
        rs1        = 0;
        rs2        = 0;
        rd         = 0;
        write_data = 0;

        #10;
        // Test 1: Write 0xABCD1234 to x5
        reg_write  = 1;
        rd         = 5;
        write_data = 32'hABCD_1234;
        #10;

        // Test 2: Write 0x5555AAAA to x10
        rd         = 10;
        write_data = 32'h5555_AAAA;
        #10;

        // Test 3: Try writing to x0 (Must fail / stay 0)
        rd         = 0;
        write_data = 32'hFFFF_FFFF;
        #10;

        // Test 4: Read back x5 on rs1 and x10 on rs2
        reg_write  = 0;
        rs1        = 5;
        rs2        = 10;
        #10;

        // Test 5: Read x0 on rs1 (Must return 0)
        rs1        = 0;
        #10;

        $display("Register File Test Complete!");
        $finish;
    end
endmodule
