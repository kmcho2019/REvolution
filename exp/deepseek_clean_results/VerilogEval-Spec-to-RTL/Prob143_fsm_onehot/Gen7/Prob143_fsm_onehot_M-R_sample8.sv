module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Next state logic
assign next_state[0] = (~in & (|state[7:0])) |  // From S0-S7
                      (~in & (state[8] | state[9])) |  // From S8,S9
                      (in & state[5] & ~state[6]);  // From S5 when in=0

assign next_state[1] = (in & state[0]) |  // From S0
                       (in & (state[8] | state[9]));  // From S8,S9

assign next_state[2] = in & state[1];  // From S1
assign next_state[3] = in & state[2];  // From S2
assign next_state[4] = in & state[3];  // From S3
assign next_state[5] = in & state[4];  // From S4
assign next_state[6] = in & state[5];  // From S5
assign next_state[7] = in & (state[6] | state[7]);  // From S6 or S7
assign next_state[8] = ~in & state[5];  // From S5
assign next_state[9] = ~in & state[6];  // From S6

// Output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

endmodule