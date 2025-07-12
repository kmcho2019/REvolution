module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero = ~in;
    wire one  =  in;

    // next_state[0] transitions: from S0,S1,S2,S3,S4,S7,S8,S9 when in=0
    assign next_state[0] = (state[0] & zero) | 
                           (state[1] & zero) | 
                           (state[2] & zero) | 
                           (state[3] & zero) | 
                           (state[4] & zero) | 
                           (state[7] & zero) | 
                           (state[8] & zero) | 
                           (state[9] & zero);

    // next_state[1]: from S0,S8,S9 when in=1
    assign next_state[1] = (state[0] & one) | 
                           (state[8] & one) | 
                           (state[9] & one);

    // next_state[2] from S1 when in=1
    assign next_state[2] = state[1] & one;

    // next_state[3] from S2 when in=1
    assign next_state[3] = state[2] & one;

    // next_state[4] from S3 when in=1
    assign next_state[4] = state[3] & one;

    // next_state[5] from S4 when in=1
    assign next_state[5] = state[4] & one;

    // next_state[6] from S5 when in=1
    assign next_state[6] = state[5] & one;

    // next_state[7] from S6 and S7 when in=1
    assign next_state[7] = (state[6] & one) | (state[7] & one);

    // next_state[8] from S5 when in=0
    assign next_state[8] = state[5] & zero;

    // next_state[9] from S6 when in=0
    assign next_state[9] = state[6] & zero;

    // Outputs as specified:
    // out1 = 1 for states S8 or S9
    assign out1 = state[8] | state[9];

    // out2 = 1 for states S7 or S9
    assign out2 = state[7] | state[9];

endmodule