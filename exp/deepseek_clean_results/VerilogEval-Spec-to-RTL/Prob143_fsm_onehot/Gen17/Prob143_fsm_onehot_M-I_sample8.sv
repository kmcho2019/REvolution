module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input for efficiency
wire not_in = ~in;

// Common transition patterns
wire to_S0 = (state[0] | state[1] | state[2] | state[3] | state[4] | 
              state[7] | state[8] | state[9]) & not_in;
wire to_S1 = (state[0] | state[8] | state[9]) & in;

// Output logic - optimized shared expression
wire active_out_states = state[7] | state[8] | state[9];
assign out1 = active_out_states & ~state[7];  // S8 or S9
assign out2 = active_out_states & ~state[8];  // S7 or S9

// Next state logic - balanced and optimized
assign next_state[0] = to_S0;
assign next_state[1] = to_S1;
assign next_state[2] = state[1] & in;
assign next_state[3] = state[2] & in;
assign next_state[4] = state[3] & in;
assign next_state[5] = state[4] & in;
assign next_state[6] = state[5] & in;
assign next_state[7] = (state[6] | state[7]) & in;
assign next_state[8] = state[5] & not_in;
assign next_state[9] = state[6] & not_in;

endmodule