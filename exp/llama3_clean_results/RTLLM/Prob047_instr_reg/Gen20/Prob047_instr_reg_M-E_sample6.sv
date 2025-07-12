module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [2:0] state;  // Finite state machine state
reg [7:0] instr_reg;  // Register to store the instruction

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        state <= 3'd0;  // Reset state to IDLE
        instr_reg <= 8'd0;  // Reset instruction register
    end else begin
        case (state)
            3'd0: begin  // IDLE state
                if (fetch == 2'b01 || fetch == 2'b10) begin
                    state <= 3'd1;  // Transition to FETCH_INSTR state
                end
            end
            3'd1: begin  // FETCH_INSTR state
                instr_reg <= data;  // Capture instruction
                state <= 3'd2;  // Transition to PROCESS_INSTR state
            end
            3'd2: begin  // PROCESS_INSTR state
                // Extract opcode, register address, and full 8-bit data
                ins <= instr_reg[7:5];
                ad1 <= instr_reg[4:0];
                ad2 <= instr_reg;
                state <= 3'd0;  // Transition back to IDLE state
            end
            default: begin
                state <= 3'd0;  // Reset state to IDLE
            end
        endcase
    end
end

endmodule