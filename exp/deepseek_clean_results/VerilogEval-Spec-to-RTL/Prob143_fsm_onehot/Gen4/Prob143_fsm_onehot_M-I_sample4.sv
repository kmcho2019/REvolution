module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Common transition terms
wire transition_to_S0 = ~in;
wire transition_to_S1 = in & (state[0] | state[8] | state[9]);

// Next state logic using parallel bitwise operations
assign next_state[0] = transition_to_S0 & (|state[7:0]) |  // S0-S7
                      (state[8] & transition_to_S0) |
                      (state[9] & transition_to_S0);

assign next_state[1] = transition_to_S1;
assign next_state[2] = in & state[1];
assign next_state[3] = in & state[2];
assign next_state[4] = in & state[3];
assign next_state[5] = in & state[4];
assign next_state[6] = in & state[5];
assign next_state[7] = in & (state[6] | state[7]);
assign next_state[8] = ~in & state[5];
assign next_state[9] = ~in & state[6];

// Output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

endmodule