module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Explicit combinational next_state logic for each next_state bit
    // For each next state Sx, identify all (state, in) pairs that lead to Sx,
    // then OR those terms.

    // S0: from S0 with in=0, S1 with in=0, S2 with in=0, S3 with in=0,
    //     S4 with in=0, S7 with in=0, S8 with in=0, S9 with in=0
    assign next_state[0] = 
          (state[0] & ~in)
        | (state[1] & ~in)
        | (state[2] & ~in)
        | (state[3] & ~in)
        | (state[4] & ~in)
        | (state[7] & ~in)
        | (state[8] & ~in)
        | (state[9] & ~in);

    // S1: from S0 with in=1, S8 with in=1, S9 with in=1
    assign next_state[1] =
          (state[0] & in)
        | (state[8] & in)
        | (state[9] & in);

    // S2: from S1 with in=1
    assign next_state[2] = (state[1] & in);

    // S3: from S2 with in=1
    assign next_state[3] = (state[2] & in);

    // S4: from S3 with in=1
    assign next_state[4] = (state[3] & in);

    // S5: from S4 with in=1
    assign next_state[5] = (state[4] & in);

    // S6: from S5 with in=1
    assign next_state[6] = (state[5] & in);

    // S7: from S6 with in=1, S7 with in=1
    assign next_state[7] =
          (state[6] & in)
        | (state[7] & in);

    // S8: from S5 with in=0
    assign next_state[8] = (state[5] & ~in);

    // S9: from S6 with in=0
    assign next_state[9] = (state[6] & ~in);

    // Outputs per state:
    // out1 = 1 if state is S8 or S9
    // out2 = 1 if state is S7 or S9
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule