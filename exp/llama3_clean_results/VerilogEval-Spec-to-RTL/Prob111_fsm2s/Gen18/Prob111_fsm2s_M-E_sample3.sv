module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Two bits for one-hot encoding of OFF and ON states

// State transition logic
always_comb begin
    case (state)
        2'b01: // Current state is OFF
            if (j) begin
                state = 2'b10; // Transition to ON
            end else begin
                state = 2'b01; // Stay in OFF
            end
        2'b10: // Current state is ON
            if (k) begin
                state = 2'b01; // Transition to OFF
            end else begin
                state = 2'b10; // Stay in ON
            end
        default: // Invalid state, reset to OFF
            state = 2'b01;
    endcase
end

// Synchronous state update
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Reset to OFF state
    end else begin
        // No direct assignment, use the combinational logic output
        // But we need to register the state for the next clock cycle
        // Hence, we introduce a temporary register 'next_state'
        reg [1:0] next_state;
        case (state)
            2'b01: // Current state is OFF
                if (j) begin
                    next_state = 2'b10; // Transition to ON
                end else begin
                    next_state = 2'b01; // Stay in OFF
                end
            2'b10: // Current state is ON
                if (k) begin
                    next_state = 2'b01; // Transition to OFF
                end else begin
                    next_state = 2'b10; // Stay in ON
                end
            default: // Invalid state, reset to OFF
                next_state = 2'b01;
        endcase
        state <= next_state; // Update state based on next_state calculation
    end
end

// Output logic
assign out = state[1]; // Output is '1' when in ON state

endmodule