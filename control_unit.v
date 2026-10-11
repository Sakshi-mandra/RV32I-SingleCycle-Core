module ControlUnit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       zero_flag,
    input  wire       lt_flag,
    input  wire       ltu_flag,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_write,
    output reg  [1:0] result_src, // 00: ALU, 01: Mem, 10: PC+4
    output reg        pc_src,     // 0: PC+4, 1: Branch/Jump Target
    output reg        jalr,
    output reg        auipc,
    output reg  [1:0] alu_op
);
    reg branch;

    always @(*) begin
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_write  = 1'b0;
        result_src = 2'b00;
        branch     = 1'b0;
        jalr       = 1'b0;
        auipc      = 1'b0;
        alu_op     = 2'b00;

        case (opcode)
            7'b0110011: begin // R-Type
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end
            7'b0010011: begin // I-Type ALU
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b11;
            end
            7'b0000011: begin // Load (LB, LH, LW, LBU, LHU)
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b01;
                alu_op     = 2'b00;
            end
            7'b0100011: begin // Store (SB, SH, SW)
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end
            7'b1100011: begin // Branch
                branch = 1'b1;
                alu_op = 2'b01;
            end
            7'b1101111: begin // JAL
                reg_write  = 1'b1;
                result_src = 2'b10;
                branch     = 1'b1;
            end
            7'b1100111: begin // JALR
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b10;
                jalr       = 1'b1;
            end
            7'b0110111: begin // LUI
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                result_src = 2'b00;
            end
            7'b0010111: begin // AUIPC
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                auipc      = 1'b1;
                result_src = 2'b00;
            end
            default: ;
        endcase
    end

    // Branch decision logic for all 6 branch instructions
    reg branch_taken;
    always @(*) begin
        case (funct3)
            3'b000: branch_taken = zero_flag;   // BEQ
            3'b001: branch_taken = ~zero_flag;  // BNE
            3'b100: branch_taken = lt_flag;     // BLT
            3'b101: branch_taken = ~lt_flag;    // BGE
            3'b110: branch_taken = ltu_flag;    // BLTU
            3'b111: branch_taken = ~ltu_flag;   // BGEU
            default: branch_taken = 1'b0;
        endcase
    end

    always @(*) begin
        pc_src = (branch && branch_taken) || (opcode == 7'b1101111) || jalr;
    end
endmodule
