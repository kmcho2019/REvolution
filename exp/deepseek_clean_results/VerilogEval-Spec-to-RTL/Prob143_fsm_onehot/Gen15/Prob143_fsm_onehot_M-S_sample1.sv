module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Output logic - only active in S7-S9
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |state[9:7:2]; // S7 or S9 (every other bit from 7-9)

// Next state logic - simplified
assign next_state[0] = (~in & (|state[9:0])) | 
                      (in & (state[5] | state[6])); // All transitions to S0

assign next_state[1] = in & (|state[9:8:0]); // S0, S8, S9 to S1

assign next_state[2] = in & state[1];
assign next_state[3] = in & state[2];
assign next_state[4] = in & state[3];
assign next_state[5] = in & state[4];
assign next_state[6] = in & state[5];
assign next_state[7] = in & (state[6] | state[7]);
assign next_state[8] = ~in & state[5];
assign next_state[9] = ~in & state[6];

endmodule