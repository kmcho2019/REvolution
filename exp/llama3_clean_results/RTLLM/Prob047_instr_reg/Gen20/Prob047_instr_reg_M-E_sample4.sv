module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Instruction Pre-processor Module
module instr_preproc(
    input [7:0] data,  // Instruction data
    output [2:0] opcode, // Opcode of the instruction
    output [4:0] reg_addr, // Register address
    output [7:0] imm // Immediate value
);
    always_comb begin
        // Simple example of decoding; actual implementation depends on the instruction set architecture
        opcode = data[7:5];
        reg_addr = data[4:0];
        imm = data;
    end
endmodule

// Dedicated Instruction Registers
reg [2:0] opcode_reg; // Opcode register
reg [4:0] reg_addr_reg; // Register address register
reg [7:0] imm_reg; // Immediate value register

// Dynamic Clock Gating
wire clk_gated = (fetch != 2'b00) ? clk : 1'b0;

// Instruction Pre-processor and Register Update Logic
always @(posedge clk_gated or negedge rst) begin
    if (!rst) begin
        opcode_reg <= 3'd0;
        reg_addr_reg <= 5'd0;
        imm_reg <= 8'd0;
    end else begin
        instr_preproc preproc_inst(.data(data), .opcode(opcode_reg), .reg_addr(reg_addr_reg), .imm(imm_reg));
        if (fetch == 2'b01) begin
            // Update registers based on the pre-processed instruction
            opcode_reg <= data[7:5];
            reg_addr_reg <= data[4:0];
            imm_reg <= data;
        end
    end
end

// Output Assignments
assign ins = opcode_reg; // Opcode of the instruction
assign ad1 = reg_addr_reg; // Register address
assign ad2 = imm_reg; // Immediate value or full 8-bit data

endmodule