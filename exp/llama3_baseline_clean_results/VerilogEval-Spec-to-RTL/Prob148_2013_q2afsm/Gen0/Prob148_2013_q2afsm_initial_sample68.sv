module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State table (combinational logic)
always @(*)
begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1)
                next_state = 2'b01; // Transition to state B
            else if (r[1] == 1'b1)
                next_state = 2'b10; // Transition to state C
            else if (r[2] == 1'b1)
                next_state = 2'b11; // Transition to state D
            else
                next_state = 2'b00; // Stay in state A
        2'b01: // State B
            if (r[0] == 1'b1)
                next_state = 2'b01; // Stay in state B
            else
                next_state = 2'b00; // Transition back to state A
        2'b10: // State C
            if (r[1] == 1'b1)
                next_state = 2'b10; // Stay in state C
            else
                next_state = 2'b00; // Transition back to state A
        2'b11: // State D
            if (r[2] == 1'b1)
                next_state = 2'b11; // Stay in state D
            else
                next_state = 2'b00; // Transition back to state A
        default:
            next_state = 2'b00; // Default to state A
    endcase
end

// State flip-flops (sequential logic)
always @(posedge clk)
begin
    if (!resetn)
        state <= 2'b00; // Reset to state A
    else
        state <= next_state; // Update current state
end

// Output logic
always @(*)
begin
    case (state)
        2'b00: // State A
            g = 3'b000; // No grants
        2'b01: // State B
            g = 3'b001; // Grant to device 0
        2'b10: // State C
            g = 3'b010; // Grant to device 1
        2'b11: // State D
            g = 3'b100; // Grant to device 2
        default:
            g = 3'b000; // Default to no grants
    endcase
end

endmodule