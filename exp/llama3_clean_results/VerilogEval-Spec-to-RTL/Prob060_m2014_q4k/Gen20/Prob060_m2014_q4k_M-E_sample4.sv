// State Machine-Based Shift Register Module
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [1:0] state; // State machine state
reg [3:0] shift_reg; // 4-bit shift register

// State machine transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00; // Reset state
        shift_reg <= 4'b0000; // Reset shift register
    end else begin
        case (state)
            2'b00: begin // Initial state
                shift_reg <= {shift_reg[2:0], in}; // Shift left
                state <= 2'b01; // Transition to state 1
            end
            2'b01: begin // Shift left, input bit is 0
                shift_reg <= {shift_reg[2:0], in}; // Shift left
                state <= 2'b10; // Transition to state 2
            end
            2'b10: begin // Shift left, input bit is 1
                shift_reg <= {shift_reg[2:0], in}; // Shift left
                state <= 2'b01; // Transition to state 1
            end
            default: begin // Default state
                shift_reg <= {shift_reg[2:0], in}; // Shift left
                state <= 2'b01; // Transition to state 1
            end
        endcase
    end
end

// Assign output directly from the last bit of the shift register
assign out = shift_reg[3];

endmodule