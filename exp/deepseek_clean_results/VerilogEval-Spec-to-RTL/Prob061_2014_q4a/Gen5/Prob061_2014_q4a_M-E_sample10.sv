module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Define states
typedef enum logic [1:0] {
    HOLD,    // Maintain current value
    SHIFT,   // Shift in new value
    LOAD     // Load parallel data
} state_t;

state_t current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        HOLD: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD: next_state = E ? SHIFT : HOLD;
        default: next_state = HOLD;
    endcase
end

// Data path logic
always @(*) begin
    case (current_state)
        HOLD: Q = Q;  // No change
        SHIFT: Q = w;
        LOAD: Q = R;
        default: Q = Q;
    endcase
end

// State register
always @(posedge clk) begin
    current_state <= next_state;
    // Update Q synchronously based on state
    case (next_state)
        SHIFT: Q <= w;
        LOAD: Q <= R;
        default: Q <= Q;  // Hold value
    endcase
end

endmodule