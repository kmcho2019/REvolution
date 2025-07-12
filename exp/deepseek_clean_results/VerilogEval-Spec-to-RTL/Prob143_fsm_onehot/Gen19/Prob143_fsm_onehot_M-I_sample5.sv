module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input and common terms
wire not_in = ~in;
wire state_8_or_9 = state[8] | state[9];
wire state_0_to_4_or_7 = state[0] | state[1] | state[2] | state[3] | state[4] | state[7];

// Output logic - optimized with shared terms
assign out1 = state_8_or_9;
assign out2 = state[7] | state[9];

// Next state logic - optimized and balanced
assign next_state[0] = (state_0_to_4_or_7 & not_in) | 
                       (state_8_or_9 & not_in);

assign next_state[1] = (state[0] | state_8_or_9) & in;

assign next_state[2] = state[1] & in;
assign next_state[3] = state[2] & in;
assign next_state[4] = state[3] & in;
assign next_state[5] = state[4] & in;
assign next_state[6] = state[5] & in;
assign next_state[7] = (state[6] | state[7]) & in;
assign next_state[8] = state[5] & not_in;
assign next_state[9] = state[6] & not_in;

endmodule