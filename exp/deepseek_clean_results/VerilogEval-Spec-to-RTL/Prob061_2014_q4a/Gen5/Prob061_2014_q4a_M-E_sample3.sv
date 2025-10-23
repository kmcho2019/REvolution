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
    HOLD,
    SHIFT,
    LOAD
} state_t;

state_t current_state, next_state;

// State transition logic
always_comb begin
    case (current_state)
        HOLD: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        default: next_state = HOLD;
    endcase
end

// Output logic
always @(posedge clk) begin
    current_state <= next_state;
    
    case (next_state)
        LOAD: Q <= R;
        SHIFT: Q <= w;
        HOLD: Q <= Q;
        default: Q <= Q;
    endcase
end

endmodule