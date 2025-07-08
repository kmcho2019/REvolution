module TopModule(
    input  wire        in,
    input  wire [9:0]  state,
    output wire [9:0]  next_state,
    output wire        out1,
    output wire        out2
);

// Next state signals for each current state
wire [9:0] next_from_S0, next_from_S1, next_from_S2, next_from_S3, next_from_S4;
wire [9:0] next_from_S5, next_from_S6, next_from_S7, next_from_S8, next_from_S9;

// S0 transitions
assign next_from_S0[0] = state[0] & ~in;
assign next_from_S0[1] = state[0] &  in;
assign next_from_S0[9:2] = 8'b0;

// S1 transitions
assign next_from_S1[0] = state[1] & ~in;
assign next_from_S1[2] = state[1] &  in;
assign next_from_S1[9:3] = 7'b0;

// S2 transitions
assign next_from_S2[0] = state[2] & ~in;
assign next_from_S2[3] = state[2] &  in;
assign next_from_S2[9:4] = 6'b0;

// S3 transitions
assign next_from_S3[0] = state[3] & ~in;
assign next_from_S3[4] = state[3] &  in;
assign next_from_S3[9:5] = 5'b0;

// S4 transitions
assign next_from_S4[0] = state[4] & ~in;
assign next_from_S4[5] = state[4] &  in;
assign next_from_S4[9:6] = 4'b0;

// S5 transitions
assign next_from_S5[8] = state[5] & ~in;
assign next_from_S5[6] = state[5] &  in;
assign next_from_S5[7:0] = 8'b0;
assign next_from_S5[9] = 1'b0;

// S6 transitions
assign next_from_S6[9] = state[6] & ~in;
assign next_from_S6[7] = state[6] &  in;
assign next_from_S6[6:0] = 7'b0;

// S7 transitions
assign next_from_S7[0] = state[7] & ~in;
assign next_from_S7[7] = state[7] &  in;
assign next_from_S7[9:8] = 2'b0;

// S8 transitions
assign next_from_S8[0] = state[8] & ~in;
assign next_from_S8[1] = state[8] &  in;
assign next_from_S8[9:2] = 8'b0;

// S9 transitions
assign next_from_S9[0] = state[9] & ~in;
assign next_from_S9[1] = state[9] &  in;
assign next_from_S9[9:2] = 8'b0;

// Combine all next state contributions
assign next_state = next_from_S0 | next_from_S1 | next_from_S2 | next_from_S3 | next_from_S4 |
                    next_from_S5 | next_from_S6 | next_from_S7 | next_from_S8 | next_from_S9;

// Outputs based on states
// out1 = 1 when state S8 is active (state[8])
// out2 = 1 when state S9 is active (state[9])
assign out1 = state[8];
assign out2 = state[9];

endmodule