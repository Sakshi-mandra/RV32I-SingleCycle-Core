module LoadStoreUnit (
    input  wire [2:0]  funct3,
    input  wire [1:0]  addr_offset,        // alu_result[1:0]
    input  wire [31:0] raw_read_data,
    input  wire [31:0] reg_data_2,
    output reg  [31:0] formatted_read_data,
    output reg  [31:0] formatted_write_data,
    output reg  [3:0]  byte_enable
);
    // Load Formatting (LB, LH, LW, LBU, LHU)
    always @(*) begin
        case (funct3)
            3'b000: begin // LB (Signed Byte)
                case (addr_offset)
                    2'b00: formatted_read_data = {{24{raw_read_data[7]}},  raw_read_data[7:0]};
                    2'b01: formatted_read_data = {{24{raw_read_data[15]}}, raw_read_data[15:8]};
                    2'b10: formatted_read_data = {{24{raw_read_data[23]}}, raw_read_data[23:16]};
                    2'b11: formatted_read_data = {{24{raw_read_data[31]}}, raw_read_data[31:24]};
                endcase
            end
            3'b001: begin // LH (Signed Half-Word)
                formatted_read_data = addr_offset[1] ? 
                    {{16{raw_read_data[31]}}, raw_read_data[31:16]} : 
                    {{16{raw_read_data[15]}}, raw_read_data[15:0]};
            end
            3'b010: formatted_read_data = raw_read_data; // LW (Word)
            3'b100: begin // LBU (Unsigned Byte)
                case (addr_offset)
                    2'b00: formatted_read_data = {24'b0, raw_read_data[7:0]};
                    2'b01: formatted_read_data = {24'b0, raw_read_data[15:8]};
                    2'b10: formatted_read_data = {24'b0, raw_read_data[23:16]};
                    2'b11: formatted_read_data = {24'b0, raw_read_data[31:24]};
                endcase
            end
            3'b101: begin // LHU (Unsigned Half-Word)
                formatted_read_data = addr_offset[1] ? 
                    {16'b0, raw_read_data[31:16]} : 
                    {16'b0, raw_read_data[15:0]};
            end
            default: formatted_read_data = raw_read_data;
        endcase
    end

    // Store Formatting (SB, SH, SW)
    always @(*) begin
        case (funct3)
            3'b000: begin // SB (Store Byte)
                formatted_write_data = {4{reg_data_2[7:0]}};
                byte_enable          = 4'b0001 << addr_offset;
            end
            3'b001: begin // SH (Store Half-Word)
                formatted_write_data = {2{reg_data_2[15:0]}};
                byte_enable          = addr_offset[1] ? 4'b1100 : 4'b0011;
            end
            3'b010: begin // SW (Store Word)
                formatted_write_data = reg_data_2;
                byte_enable          = 4'b1111;
            end
            default: begin
                formatted_write_data = reg_data_2;
                byte_enable          = 4'b0000;
            end
        endcase
    end
endmodule
