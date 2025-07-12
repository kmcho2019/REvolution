module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input for efficiency
wire not_in = ~in;

// Output logic - continuous assignments
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Next state logic - continuous assignments
assign next_state[0] = (state[0] & not_in) | 
                       (state[1] & not_in) | 
                       (state[2] & not_in) | 
                       (state[3] & not_in) | 
                       (state[4] & not_in) | 
                       (state[7] & not_in) | 
                       (state[8] & not_in) | 
                       (state[9] & not_in);

assign next_state[1] = (state[0] & in) | 
                       (state[8] & in) | 
                       (state[9] & in);

assign next_state[2] = state[1] & in;
assign next_state[3] = state[2] & in;
assign next_state[4] = state[3] & in;
assign next_state[5] = state[4] & in;
assign next_state[6] = state[5] & in;
assign next_state[7] = (state[6] & in) | (state[7] & in);
assign next_state[8] = state[5] & not_in;
assign next_state[9] = state[6] & not_in;

endmodule