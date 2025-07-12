module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] instr_reg;  // Single 8-bit register to store instructions

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        instr_reg <= 8'd0;  // Reset the register when rst is low
    end else if (fetch == 2'b01 || fetch == 2'b10) begin
        instr_reg <= data;  // Update the register with the new instruction
    end
end

// Direct assignments for output logic
assign ins = instr_reg[7:5];  // High 3 bits of the instruction
assign ad1 = instr_reg[4:0];  // Low 5 bits of the instruction

// Simplified logic for ad2 using ternary operator
assign ad2 = (fetch == 2'b10) ? data : 8'd0;

endmodule