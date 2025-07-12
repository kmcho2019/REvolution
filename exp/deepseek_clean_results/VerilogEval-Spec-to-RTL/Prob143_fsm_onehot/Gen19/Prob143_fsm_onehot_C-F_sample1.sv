module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input for efficiency
wire in_n = ~in;

// Output logic - simple OR of relevant states
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Next state logic - fully parallel assignments
assign next_state[0] = (state[0] | state[1] | state[2] | state[3] | state[4] | 
                      state[7] | state[8] | state[9]) & in_n | 
                      (state[5] & in_n);  // S5->S8 handled separately

assign next_state[1] = (state[0] | state[8] | state[9]) & in;
assign next_state[2] = state[1] & in;
assign next_state[3] = state[2] & in;
assign next_state[4] = state[3] & in;
assign next_state[5] = state[4] & in;
assign next_state[6] = state[5] & in;
assign next_state[7] = (state[6] | state[7]) & in;
assign next_state[8] = state[5] & in_n;
assign next_state[9] = state[6] & in_n;

endmodule