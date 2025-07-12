module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
typedef enum logic [0:0] { OFF, ON } state_t;

// Current state and next state
state_t state, next_state;

// Output out is a function of the current state
assign out = (state == ON) ? 1'b1 : 1'b0;

// State transition logic
always_comb begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule