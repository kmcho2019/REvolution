module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Next state logic using continuous assignments
assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9])) |
                       (state[5] & ~in) | (state[6] & ~in);

assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);

assign next_state[2] = state[1] & in;

assign next_state[3] = state[2] & in;

assign next_state[4] = state[3] & in;

assign next_state[5] = state[4] & in;

assign next_state[6] = state[5] & in;

assign next_state[7] = (state[6] & in) | (state[7] & in);

assign next_state[8] = state[5] & ~in;

assign next_state[9] = state[6] & ~in;

// Output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

endmodule