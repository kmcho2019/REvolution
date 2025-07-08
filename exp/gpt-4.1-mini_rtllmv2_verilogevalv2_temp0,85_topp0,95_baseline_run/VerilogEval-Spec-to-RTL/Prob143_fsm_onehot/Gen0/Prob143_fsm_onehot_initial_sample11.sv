module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

// For convenience, alias each state bit
wire s0 = state[0];
wire s1 = state[1];
wire s2 = state[2];
wire s3 = state[3];
wire s4 = state[4];
wire s5 = state[5];
wire s6 = state[6];
wire s7 = state[7];
wire s8 = state[8];
wire s9 = state[9];

// next_state bits, initialize all to 0 and assign 1 where transitions occur
// Each next_state bit is asserted if any current state transitions to that state given input

// next_state[0] = S0
// S0 --0--> S0
// S1 --0--> S0
// S2 --0--> S0
// S3 --0--> S0
// S4 --0--> S0
// S7 --0--> S0
// S8 --0--> S0
// S9 --0--> S0
assign next_state[0] =
    (s0 & ~in) |
    (s1 & ~in) |
    (s2 & ~in) |
    (s3 & ~in) |
    (s4 & ~in) |
    (s7 & ~in) |
    (s8 & ~in) |
    (s9 & ~in);

// next_state[1] = S1
// S0 --1--> S1
// S9 --1--> S1
// S8 --1--> S1
assign next_state[1] =
    (s0 & in) |
    (s9 & in) |
    (s8 & in);

// next_state[2] = S2
// S1 --1--> S2
assign next_state[2] =
    (s1 & in);

// next_state[3] = S3
// S2 --1--> S3
assign next_state[3] =
    (s2 & in);

// next_state[4] = S4
// S3 --1--> S4
assign next_state[4] =
    (s3 & in);

// next_state[5] = S5
// S4 --1--> S5
assign next_state[5] =
    (s4 & in);

// next_state[6] = S6
// S5 --1--> S6
assign next_state[6] =
    (s5 & in);

// next_state[7] = S7
// S6 --1--> S7
// S7 --1--> S7
assign next_state[7] =
    (s6 & in) |
    (s7 & in);

// next_state[8] = S8
// S5 --0--> S8
assign next_state[8] =
    (s5 & ~in);

// next_state[9] = S9
// S6 --0--> S9
assign next_state[9] =
    (s6 & ~in);

// Outputs:
// out1 is 1 only in S8 (1,0) and S9 (1,1) states
assign out1 = s8 | s9;

// out2 is 1 only in S7 (0,1) state
assign out2 = s7;

endmodule