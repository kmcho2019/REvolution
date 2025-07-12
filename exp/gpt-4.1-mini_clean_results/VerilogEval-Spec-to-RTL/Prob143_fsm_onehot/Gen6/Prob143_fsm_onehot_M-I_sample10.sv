module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0] (S0) transitions:
    // from S0 on 0
    // from S1 on 0
    // from S2 on 0
    // from S3 on 0
    // from S4 on 0
    // from S7 on 0
    // from S8 on 0
    // from S9 on 0
    assign next_state[0] =
        (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]));

    // next_state[1] (S1) transitions:
    // from S0 on 1
    // from S8 on 1
    // from S9 on 1
    assign next_state[1] =
        (in & (state[0] | state[8] | state[9]));

    // next_state[2] (S2) transitions:
    // from S1 on 1
    assign next_state[2] = in & state[1];

    // next_state[3] (S3) transitions:
    // from S2 on 1
    assign next_state[3] = in & state[2];

    // next_state[4] (S4) transitions:
    // from S3 on 1
    assign next_state[4] = in & state[3];

    // next_state[5] (S5) transitions:
    // from S4 on 1
    assign next_state[5] = in & state[4];

    // next_state[6] (S6) transitions:
    // from S5 on 1
    assign next_state[6] = in & state[5];

    // next_state[7] (S7) transitions:
    // from S6 on 1
    // from S7 on 1
    assign next_state[7] = in & (state[6] | state[7]);

    // next_state[8] (S8) transitions:
    // from S5 on 0
    assign next_state[8] = (~in) & state[5];

    // next_state[9] (S9) transitions:
    // from S6 on 0
    assign next_state[9] = (~in) & state[6];

    // Output logic:
    // out1 asserted for S8, S9
    // out2 asserted for S7, S9

    assign out1 = |(state[8] | state[9]);
    assign out2 = |(state[7] | state[9]);

endmodule