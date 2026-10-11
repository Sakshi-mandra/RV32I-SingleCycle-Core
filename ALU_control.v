module ALUControl (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7_5,
    input  wire       is_imm,
    output reg  [3:0] alu_control
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0000; // ADD (for Loads, Stores, AUIPC)
            2'b01: alu_control = 4'b0001; // SUB (for Branches)
            2'b10, 2'b11: begin           // R-Type (10) or I-Type ALU (11)
                case (funct3)
                    3'b000: alu_control = (alu_op == 2'b10 && funct7_5) ? 4'b0001 : 4'b0000; // SUB vs ADD/ADDI
                    3'b001: alu_control = 4'b0010; // SLL / SLLI
                    3'b010: alu_control = 4'b0011; // SLT / SLTI
                    3'b011: alu_control = 4'b0100; // SLTU / SLTIU
                    3'b100: alu_control = 4'b0101; // XOR / XORI
                    3'b101: alu_control = funct7_5 ? 4'b0111 : 4'b0110; // SRA/SRAI vs SRL/SRLI
                    3'b110: alu_control = 4'b1000; // OR / ORI
                    3'b111: alu_control = 4'b1001; // AND / ANDI
                    default: alu_control = 4'b0000;
                endcase
            end
            default: alu_control = 4'b0000;
        endcase
    end
endmodule
