module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in_0 = ~in;
    wire in_1 = in;

    // Next state logic factoring input conditions for reduced logic complexity
    assign next_state[0] =
           (in_0 & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]));

    assign next_state[1] =
           (in_1 & (state[0] | state[8] | state[9]));

    assign next_state[2] =
           in_1 & state[1];

    assign next_state[3] =
           in_1 & state[2];

    assign next_state[4] =
           in_1 & state[3];

    assign next_state[5] =
           in_1 & state[4];

    assign next_state[6] =
           in_1 & state[5];

    assign next_state[7] =
           in_1 & (state[6] | state[7]);

    assign next_state[8] =
           in_0 & state[5];

    assign next_state[9] =
           in_0 & state[6];

    // Outputs as before
    localparam [9:0] mask_out1 = (1 << 8) | (1 << 9);
    localparam [9:0] mask_out2 = (1 << 7) | (1 << 9);

    assign out1 = |(state & mask_out1);
    assign out2 = |(state & mask_out2);

endmodule