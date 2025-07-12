module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input and common terms
wire not_in = ~in;
wire state0_in = state[0] & in;
wire state8_or_9_in = (state[8] | state[9]) & in;
wire state1_to_4_in = (state[1] | state[2] | state[3] | state[4]) & in;
wire state5_to_7_in = (state[5] | state[6] | state[7]) & in;
wire state0_to_4_not_in = (state[0] | state[1] | state[2] | state[3] | state[4]) & not_in;
wire state7_to_9_not_in = (state[7] | state[8] | state[9]) & not_in;

// Output logic - optimized to share terms
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

// Next state logic - optimized with shared terms
assign next_state[0] = state0_to_4_not_in | state7_to_9_not_in;
assign next_state[1] = state0_in | state8_or_9_in;
assign next_state[2] = state[1] & in;
assign next_state[3] = state[2] & in;
assign next_state[4] = state[3] & in;
assign next_state[5] = state[4] & in;
assign next_state[6] = state[5] & in;
assign next_state[7] = (state[6] | state[7]) & in;
assign next_state[8] = state[5] & not_in;
assign next_state[9] = state[6] & not_in;

endmodule