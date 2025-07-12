module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state assignments by ORing transitions from all relevant current states
    assign next_state[0] =
           (state[0] & ~in)
        |  (state[1] & ~in)
        |  (state[2] & ~in)
        |  (state[3] & ~in)
        |  (state[4] & ~in)
        |  (state[7] & ~in)
        |  (state[8] & ~in)
        |  (state[9] & ~in);

    assign next_state[1] =
           (state[0] &  in)
        |  (state[8] &  in)
        |  (state[9] &  in);

    assign next_state[2] =
           (state[1] &  in);

    assign next_state[3] =
           (state[2] &  in);

    assign next_state[4] =
           (state[3] &  in);

    assign next_state[5] =
           (state[4] &  in);

    assign next_state[6] =
           (state[5] &  in);

    assign next_state[7] =
           (state[6] &  in)
        |  (state[7] &  in);

    assign next_state[8] =
           (state[5] & ~in);

    assign next_state[9] =
           (state[6] & ~in);

    // Outputs are based on current states
    assign out1 = |(state & 10'b1100000000); // states S8 and S9 produce out1 = 1
    assign out2 = |(state & ((1 << 7) | (1 << 9))); // states S7 and S9 produce out2 = 1

endmodule