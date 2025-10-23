module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // For each next_state bit, determine if any current state transitions into it.
    // next_state[0] = Next state S0:
    // from S0 on in=0, S1 on in=0, S2 on in=0, S3 on in=0, S4 on in=0,
    // S7 on in=0, S8 on in=0, S9 on in=0
    // S7 also on in=0 -> S0
    assign next_state[0] = 
           state[0] & ~in
        |  state[1] & ~in
        |  state[2] & ~in
        |  state[3] & ~in
        |  state[4] & ~in
        |  state[7] & ~in
        |  state[8] & ~in
        |  state[9] & ~in;

    // next_state[1] = S1: from S0 on in=1, S8 on in=1, S9 on in=1
    assign next_state[1] = 
           state[0] & in
        |  state[8] & in
        |  state[9] & in;

    // next_state[2] = S2: from S1 on in=1
    assign next_state[2] = 
           state[1] & in;

    // next_state[3] = S3: from S2 on in=1
    assign next_state[3] = 
           state[2] & in;

    // next_state[4] = S4: from S3 on in=1
    assign next_state[4] = 
           state[3] & in;

    // next_state[5] = S5: from S4 on in=1
    assign next_state[5] = 
           state[4] & in;

    // next_state[6] = S6: from S5 on in=1
    assign next_state[6] = 
           state[5] & in;

    // next_state[7] = S7: from S6 on in=1, S7 on in=1
    assign next_state[7] = 
           state[6] & in
        |  state[7] & in;

    // next_state[8] = S8: from S5 on in=0
    assign next_state[8] = 
           state[5] & ~in;

    // next_state[9] = S9: from S6 on in=0
    assign next_state[9] = 
           state[6] & ~in;

    // Outputs:
    // out1 = 1 if S8 or S9 active
    assign out1 = state[8] | state[9];
    // out2 = 1 if S7 or S9 active
    assign out2 = state[7] | state[9];

endmodule