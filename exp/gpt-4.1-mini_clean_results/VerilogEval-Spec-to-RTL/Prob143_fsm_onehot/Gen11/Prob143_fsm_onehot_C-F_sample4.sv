module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0] = transitions to S0: many states on input=0
    assign next_state[0] =
           (state[0] & ~in)
        |  (state[1] & ~in)
        |  (state[2] & ~in)
        |  (state[3] & ~in)
        |  (state[4] & ~in)
        |  (state[7] & ~in)
        |  (state[8] & ~in)
        |  (state[9] & ~in);

    // next_state[1] = transitions to S1
    assign next_state[1] =
           (state[0] & in)
        |  (state[8] & in)
        |  (state[9] & in);

    // next_state[2] = transitions to S2
    assign next_state[2] = state[1] & in;

    // next_state[3] = transitions to S3
    assign next_state[3] = state[2] & in;

    // next_state[4] = transitions to S4
    assign next_state[4] = state[3] & in;

    // next_state[5] = transitions to S5
    assign next_state[5] = state[4] & in;

    // next_state[6] = transitions to S6
    assign next_state[6] = state[5] & in;

    // next_state[7] = transitions to S7 (from S6 or S7 on in=1)
    assign next_state[7] =
           (state[6] & in)
        |  (state[7] & in);

    // next_state[8] = transitions to S8 (from S5 on in=0)
    assign next_state[8] = state[5] & ~in;

    // next_state[9] = transitions to S9 (from S6 on in=0)
    assign next_state[9] = state[6] & ~in;

    // Outputs:
    // out1 = 1 if S8 or S9 active (states 8 or 9)
    // out2 = 1 if S7 or S9 active (states 7 or 9)
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule