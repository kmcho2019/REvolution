module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Output logic remains the same
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// State transition logic using continuous assignments
assign next_state[0] = (~in & (|state[9:0])) |  // Default transition to S0
                      (~in & state[5]) |       // S5 -> S8 when in=0
                      (~in & state[6]) |       // S6 -> S9 when in=0
                      (~in & state[7]) |       // S7 -> S0 when in=0
                      (~in & state[8]) |       // S8 -> S0 when in=0
                      (~in & state[9]);        // S9 -> S0 when in=0

assign next_state[1] = (in & state[0]) |      // S0 -> S1 when in=1
                      (in & state[8]) |       // S8 -> S1 when in=1
                      (in & state[9]);        // S9 -> S1 when in=1

assign next_state[2] = in & state[1];         // S1 -> S2 when in=1
assign next_state[3] = in & state[2];         // S2 -> S3 when in=1
assign next_state[4] = in & state[3];         // S3 -> S4 when in=1
assign next_state[5] = in & state[4];         // S4 -> S5 when in=1

assign next_state[6] = in & state[5];         // S5 -> S6 when in=1
assign next_state[7] = in & state[6];         // S6 -> S7 when in=1

assign next_state[8] = ~in & state[5];        // S5 -> S8 when in=0
assign next_state[9] = ~in & state[6];        // S6 -> S9 when in=0

// S7 stays in S7 when in=1 (handled by default 0 and next_state[7] above)
endmodule