module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State encoding
typedef enum logic [1:0] {
    HOLD  = 2'b00,
    LOAD  = 2'b01,
    SHIFT = 2'b10
} state_t;

state_t current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        HOLD: begin
            if (L) next_state = LOAD;
            else if (E) next_state = SHIFT;
            else next_state = HOLD;
        end
        LOAD: next_state = HOLD;
        SHIFT: next_state = HOLD;
        default: next_state = HOLD;
    endcase
end

// Output logic
always @(posedge clk) begin
    current_state <= next_state;
    
    case (next_state)
        LOAD: Q <= R;
        SHIFT: Q <= w;
        HOLD: Q <= Q;  // Explicit hold - could be optimized away
        default: Q <= Q;
    endcase
end

endmodule