module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next state to zero
assign next_state = 10'b0;

// S0 transitions
assign next_state[0] = (state[0] && !in) || (state[1] && !in) || (state[2] && !in) || (state[3] && !in) || (state[4] && !in) || (state[5] && !in) || (state[6] && !in && !out1) || (state[7] && !in) || (state[8] && !in) || (state[9] && !in);

// S1 transitions
assign next_state[1] = (state[0] && in) || (state[8] && in) || (state[9] && in);

// S2 transitions
assign next_state[2] = state[1] && in;

// S3 transitions
assign next_state[3] = state[2] && in;

// S4 transitions
assign next_state[4] = state[3] && in;

// S5 transitions
assign next_state[5] = state[4] && in;

// S6 transitions
assign next_state[6] = state[5] && in;

// S7 transitions
assign next_state[7] = state[5] && in || state[6] && in;

// S8 transitions
assign next_state[8] = state[5] && !in;

// S9 transitions
assign next_state[9] = state[6] && !in;

// Output logic
assign out1 = state[8] || state[9] || state[7];
assign out2 = state[7] || state[9];

endmodule