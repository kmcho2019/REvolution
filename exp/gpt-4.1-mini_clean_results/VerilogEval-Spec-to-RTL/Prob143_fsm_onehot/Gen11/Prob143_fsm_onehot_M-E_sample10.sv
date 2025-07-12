module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0] (S0) is next when:
    // From S0 on 0
    // From S1 on 0
    // From S2 on 0
    // From S3 on 0
    // From S4 on 0
    // From S7 on 0
    // From S8 on 0
    // From S9 on 0
    wire next0 = (state[0] & ~in) |
                 (state[1] & ~in) |
                 (state[2] & ~in) |
                 (state[3] & ~in) |
                 (state[4] & ~in) |
                 (state[7] & ~in) |
                 (state[8] & ~in) |
                 (state[9] & ~in);

    // next_state[1] (S1) is next when:
    // From S0 on 1
    // From S8 on 1
    // From S9 on 1
    wire next1 = (state[0] & in) |
                 (state[8] & in) |
                 (state[9] & in);

    // next_state[2] (S2) is next when:
    // From S1 on 1
    wire next2 = (state[1] & in);

    // next_state[3] (S3) is next when:
    // From S2 on 1
    wire next3 = (state[2] & in);

    // next_state[4] (S4) is next when:
    // From S3 on 1
    wire next4 = (state[3] & in);

    // next_state[5] (S5) is next when:
    // From S4 on 1
    wire next5 = (state[4] & in);

    // next_state[6] (S6) is next when:
    // From S5 on 1
    wire next6 = (state[5] & in);

    // next_state[7] (S7) is next when:
    // From S6 on 1
    // From S7 on 1
    wire next7 = (state[6] & in) |
                 (state[7] & in);

    // next_state[8] (S8) is next when:
    // From S5 on 0
    wire next8 = (state[5] & ~in);

    // next_state[9] (S9) is next when:
    // From S6 on 0
    wire next9 = (state[6] & ~in);

    assign next_state = {next9, next8, next7, next6, next5, next4, next3, next2, next1, next0};

    // Outputs:
    // out1 = 1 if state S8 or S9 active
    assign out1 = state[8] | state[9];
    // out2 = 1 if state S7 or S9 active
    assign out2 = state[7] | state[9];

endmodule