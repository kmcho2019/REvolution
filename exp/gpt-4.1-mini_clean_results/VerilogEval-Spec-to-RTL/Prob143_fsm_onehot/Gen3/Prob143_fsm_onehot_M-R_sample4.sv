module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0]: from S0..S4, S7..S9 with in=0 transitions to S0
    assign next_state[0] =
        (state[0] ? ~in : 1'b0) |
        (state[1] ? ~in : 1'b0) |
        (state[2] ? ~in : 1'b0) |
        (state[3] ? ~in : 1'b0) |
        (state[4] ? ~in : 1'b0) |
        (state[7] ? ~in : 1'b0) |
        (state[8] ? ~in : 1'b0) |
        (state[9] ? ~in : 1'b0);

    // next_state[1]: from S0,S8,S9 with in=1 to S1
    assign next_state[1] =
        (state[0] ? in : 1'b0) |
        (state[8] ? in : 1'b0) |
        (state[9] ? in : 1'b0);

    // next_state[2]: from S1 with in=1 to S2
    assign next_state[2] =
        (state[1] ? in : 1'b0);

    // next_state[3]: from S2 with in=1 to S3
    assign next_state[3] =
        (state[2] ? in : 1'b0);

    // next_state[4]: from S3 with in=1 to S4
    assign next_state[4] =
        (state[3] ? in : 1'b0);

    // next_state[5]: from S4 with in=1 to S5
    assign next_state[5] =
        (state[4] ? in : 1'b0);

    // next_state[6]: from S5 with in=1 to S6
    assign next_state[6] =
        (state[5] ? in : 1'b0);

    // next_state[7]: from S6,S7 with in=1 to S7
    assign next_state[7] =
        (state[6] ? in : 1'b0) |
        (state[7] ? in : 1'b0);

    // next_state[8]: from S5 with in=0 to S8
    assign next_state[8] =
        (state[5] ? ~in : 1'b0);

    // next_state[9]: from S6 with in=0 to S9
    assign next_state[9] =
        (state[6] ? ~in : 1'b0);

    // Outputs from specified states
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule