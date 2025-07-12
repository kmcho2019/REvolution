module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [15:0] instruction_buffer;  // 16-bit register to store instructions from both sources

// Reset logic using always block
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        instruction_buffer <= 16'd0;
    end else if (fetch == 2'b01) begin
        instruction_buffer[7:0] <= data;  // Update ins_p1 field
    end else if (fetch == 2'b10) begin
        instruction_buffer[15:8] <= data;  // Update ins_p2 field
    end
end

// Output logic
assign ins = instruction_buffer[7:5];  // High 3 bits of the instruction in ins_p1
assign ad1 = instruction_buffer[4:0];  // Low 5 bits of the instruction in ins_p1
assign ad2 = instruction_buffer[15:8];  // Full 8-bit data from ins_p2

endmodule