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
    LOAD,
    SHIFT
} state_t;

state_t current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        HOLD: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        LOAD: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        SHIFT: next_state = L ? LOAD : (E ? SHIFT : HOLD);
        default: next_state = HOLD;
    endcase
end

// State register and output logic
always @(posedge clk) begin
    current_state <= next_state;
    
    case (next_state)
        LOAD: Q <= R;
        SHIFT: Q <= w;
        HOLD: Q <= Q;  // Explicit hold for clarity
    endcase
end

endmodule