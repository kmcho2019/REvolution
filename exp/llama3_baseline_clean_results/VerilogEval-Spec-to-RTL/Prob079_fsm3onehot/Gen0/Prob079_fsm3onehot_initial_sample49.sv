module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// One-hot state encoding
wire state_A = state[0];
wire state_B = state[1];
wire state_C = state[2];
wire state_D = state[3];

// State transition logic
assign next_state[0] = (state_A && !in) || (state_C && !in) || (state_D && !in);
assign next_state[1] = (state_A && in) || (state_B && in) || (state_D && in);
assign next_state[2] = (state_B && !in) || (state_C && in);
assign next_state[3] = (state_C && in);

// Output logic
assign out = state_D;

endmodule