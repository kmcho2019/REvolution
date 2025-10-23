module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [15:0] instr_reg;  // 16-bit register to store concatenated instructions

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        instr_reg <= 16'd0;  // Reset the 16-bit register to zero when rst is low
    end else begin
        case (fetch)
            2'b01: instr_reg[7:0] <= data;  // Update the lower 8 bits with the new instruction
            2'b10: instr_reg[15:8] <= data;  // Update the upper 8 bits with the new instruction
            default: ;  // No update when fetch is not 2'b01 or 2'b10
        endcase
    end
end

// Derive outputs directly from the stored instructions
assign ins = instr_reg[7:5];  // High 3 bits of the instruction
assign ad1 = instr_reg[4:0];  // Low 5 bits of the instruction
assign ad2 = instr_reg[15:8];  // Full 8-bit data from the second source

endmodule