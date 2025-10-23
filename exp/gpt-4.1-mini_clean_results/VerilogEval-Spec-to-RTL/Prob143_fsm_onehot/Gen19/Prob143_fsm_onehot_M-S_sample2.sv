module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Masks for grouped transitions
    localparam [9:0] MASK_S0_S4_S7_S8_S9 = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<7)|(1<<8)|(1<<9);
    localparam [9:0] MASK_S0_S8_S9       = (1<<0)|(1<<8)|(1<<9);

    // next_state[0]: go to S0 if input=0 and in states S0,S1,S2,S3,S4,S7,S8,S9
    assign next_state[0] = (~in) & (state & MASK_S0_S4_S7_S8_S9);

    // next_state[1]: go to S1 if input=1 and in states S0,S8,S9
    assign next_state[1] = in & (state & MASK_S0_S8_S9);

    // next_state[2]: S1 and input=1
    assign next_state[2] = state[1] & in;

    // next_state[3]: S2 and input=1
    assign next_state[3] = state[2] & in;

    // next_state[4]: S3 and input=1
    assign next_state[4] = state[3] & in;

    // next_state[5]: S4 and input=1
    assign next_state[5] = state[4] & in;

    // next_state[6]: S5 and input=1
    assign next_state[6] = state[5] & in;

    // next_state[7]: S6 or S7 and input=1
    assign next_state[7] = (state[6] | state[7]) & in;

    // next_state[8]: S5 and input=0
    assign next_state[8] = state[5] & ~in;

    // next_state[9]: S6 and input=0
    assign next_state[9] = state[6] & ~in;

    // Outputs
    assign out1 = |(state & ((1<<8) | (1<<9))); // S8 or S9
    assign out2 = |(state & ((1<<7) | (1<<9))); // S7 or S9

endmodule