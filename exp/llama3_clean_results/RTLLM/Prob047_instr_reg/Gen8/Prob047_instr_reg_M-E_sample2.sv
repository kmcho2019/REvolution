module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Parameterizable buffer size
parameter BUFFER_SIZE = 2;

reg [7:0] instruction_buffer [BUFFER_SIZE - 1:0]; // Buffer to store instructions

// State machine to manage buffer updates
reg [1:0] buffer_ptr; // Pointer to the current buffer entry
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        buffer_ptr <= 2'b00;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            instruction_buffer[i] <= 8'd0;
        end
    end else begin
        case (fetch)
            2'b01: begin
                instruction_buffer[0] <= data; // Update first entry
            end
            2'b10: begin
                instruction_buffer[1] <= data; // Update second entry
            end
            default: begin
                // No update
            end
        endcase
    end
end

// Derive outputs from the buffer
assign ins = instruction_buffer[0][7:5]; // High 3 bits from the first entry
assign ad1 = instruction_buffer[0][4:0]; // Low 5 bits from the first entry
assign ad2 = instruction_buffer[1]; // Full 8 bits from the second entry

endmodule