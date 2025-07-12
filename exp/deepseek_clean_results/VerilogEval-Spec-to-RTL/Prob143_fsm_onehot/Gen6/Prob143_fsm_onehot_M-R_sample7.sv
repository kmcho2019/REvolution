module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Next state logic - each bit computed independently
assign next_state[0] = (~in & (|state[9:0])) |  // From any state with in=0
                       (~in & state[7]) |        // From S7 with in=0
                       (~in & state[8]) |       // From S8 with in=0
                       (~in & state[9]);         // From S9 with in=0

assign next_state[1] = (in & state[0]) |        // From S0 with in=1
                       (in & state[8]) |        // From S8 with in=1
                       (in & state[9]);         // From S9 with in=1

assign next_state[2] = in & state[1];           // From S1 with in=1
assign next_state[3] = in & state[2];           // From S2 with in=1
assign next_state[4] = in & state[3];           // From S3 with in=1
assign next_state[5] = in & state[4];           // From S4 with in=1

assign next_state[6] = in & state[5];           // From S5 with in=1
assign next_state[7] = (in & state[6]) |        // From S6 with in=1
                       (in & state[7]);         // From S7 with in=1

assign next_state[8] = ~in & state[5];          // From S5 with in=0
assign next_state[9] = ~in & state[6];          // From S6 with in=0

// Output logic
assign out1 = state[8] | state[9];              // S8 or S9
assign out2 = state[7] | state[9];              // S7 or S9

endmodule