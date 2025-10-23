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

// Sequential logic to update instr_reg based on fetch and rst
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        instr_reg <= 8'd0;  // Reset instr_reg when rst is low
    end else if (fetch == 2'b01 || fetch == 2'b10) begin
        instr_reg <= data;  // Update instr_reg with new instruction
    end
end

// Output logic using direct assignments
assign ins = (fetch == 2'b01) ? data[7:5] : (fetch == 2'b10) ? instr_reg[7:5] : 3'd0;  // High 3 bits of the instruction
assign ad1 = (fetch == 2'b01) ? data[4:0] : (fetch == 2'b10) ? instr_reg[4:0] : 5'd0;  // Low 5 bits of the instruction
assign ad2 = (fetch == 2'b10) ? data : 8'd0;  // Full 8-bit data from the second source

endmodule