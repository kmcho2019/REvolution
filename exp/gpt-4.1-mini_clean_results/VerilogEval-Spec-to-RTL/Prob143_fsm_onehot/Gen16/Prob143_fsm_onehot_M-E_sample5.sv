module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Input signals inverted for clarity
    wire inv_in = ~in;

    // next_state[0] (S0) is reachable from many states when in == 0
    // S0(0), S1(1), S2(2), S3(3), S4(4), S7(7), S8(8), S9(9) with in==0
    assign next_state[0] = 
          (state[0] & inv_in)
        | (state[1] & inv_in)
        | (state[2] & inv_in)
        | (state[3] & inv_in)
        | (state[4] & inv_in)
        | (state[7] & inv_in)
        | (state[8] & inv_in)
        | (state[9] & inv_in);

    // next_state[1] (S1)
    // From S0(0), S8(8), S9(9) with in==1
    assign next_state[1] = 
          (state[0] & in)
        | (state[8] & in)
        | (state[9] & in);

    // next_state[2] (S2) from S1 with in==1
    assign next_state[2] = state[1] & in;

    // next_state[3] (S3) from S2 with in==1
    assign next_state[3] = state[2] & in;

    // next_state[4] (S4) from S3 with in==1
    assign next_state[4] = state[3] & in;

    // next_state[5] (S5) from S4 with in==1
    assign next_state[5] = state[4] & in;

    // next_state[6] (S6) from S5 with in==1
    assign next_state[6] = state[5] & in;

    // next_state[7] (S7) from S6 or S7 with in==1
    assign next_state[7] = (state[6] & in) | (state[7] & in);

    // next_state[8] (S8) from S5 with in==0
    assign next_state[8] = state[5] & inv_in;

    // next_state[9] (S9) from S6 with in==0
    assign next_state[9] = state[6] & inv_in;

    // Outputs according to states
    // out1 = 1 when in S8 or S9
    assign out1 = state[8] | state[9];

    // out2 = 1 when in S7 or S9
    assign out2 = state[7] | state[9];

endmodule