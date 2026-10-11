module RISCV_Core (
    input wire clk,
    input wire reset
);
    // Interconnect Wire Declarations
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4 = pc + 32'd4;
    wire [31:0] pc_target;
    wire [31:0] instr;

    wire        reg_write;
    wire        alu_src;
    wire        mem_write;
    wire [1:0]  result_src;
    wire        pc_src;
    wire        jalr;
    wire        auipc;
    wire [1:0]  alu_op;
    wire [3:0]  alu_control;

    wire [31:0] reg_data1;
    wire [31:0] reg_data2;
    wire [31:0] imm_ext;
    wire [31:0] alu_in_a;
    wire [31:0] alu_in_b;
    wire [31:0] alu_result;

    wire        zero_flag;
    wire        lt_flag;
    wire        ltu_flag;

    wire [31:0] raw_mem_read;
    wire [31:0] formatted_mem_read;
    wire [31:0] formatted_mem_write;
    wire [3:0]  byte_enable;
    reg  [31:0] write_back_data;

    // ------------------------------------------------------------------------
    // Module Instantiations
    // ------------------------------------------------------------------------
    ProgramCounter PC_Unit (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_next),
        .pc_out(pc)
    );

    InstructionMemory InstructionMem (
        .addr(pc),
        .instr(instr)
    );

    ControlUnit MainControl (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .zero_flag(zero_flag),
        .lt_flag(lt_flag),
        .ltu_flag(ltu_flag),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .pc_src(pc_src),
        .jalr(jalr),
        .auipc(auipc),
        .alu_op(alu_op)
    );

    ALUControl ALUDecoder (
        .alu_op(alu_op),
        .funct3(instr[14:12]),
        .funct7_5(instr[30]),
        .is_imm(instr[6:0] == 7'b0010011),
        .alu_control(alu_control)
    );

    RegisterFile RegFile (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .write_data(write_back_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    ImmGen ImmediateGenerator (
        .instr(instr),
        .imm_ext(imm_ext)
    );

    // ALU Input Select Muxes
    assign alu_in_a = auipc ? pc : reg_data1;
    assign alu_in_b = (instr[6:0] == 7'b0110111) ? imm_ext : (alu_src ? imm_ext : reg_data2);

    ALU ExecutionUnit (
        .a(alu_in_a),
        .b(alu_in_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero_flag),
        .less_than(lt_flag),
        .less_than_u(ltu_flag)
    );

    LoadStoreUnit SubWordDecoder (
        .funct3(instr[14:12]),
        .addr_offset(alu_result[1:0]),
        .raw_read_data(raw_mem_read),
        .reg_data_2(reg_data2),
        .formatted_read_data(formatted_mem_read),
        .formatted_write_data(formatted_mem_write),
        .byte_enable(byte_enable)
    );

    DataMemory DataMem (
        .clk(clk),
        .mem_write(mem_write),
        .byte_enable(byte_enable),
        .addr(alu_result),
        .write_data(formatted_mem_write),
        .read_data(raw_mem_read)
    );

    // Write-Back Mux
    always @(*) begin
        case (result_src)
            2'b00: write_back_data = alu_result;
            2'b01: write_back_data = formatted_mem_read;
            2'b10: write_back_data = pc_plus_4;
            default: write_back_data = alu_result;
        endcase
    end

    // Next PC Target Logic
    assign pc_target = jalr ? (reg_data1 + imm_ext) & ~32'd1 : (pc + imm_ext);
    assign pc_next   = pc_src ? pc_target : pc_plus_4;

endmodule
