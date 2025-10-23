module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,      // one-hot encoded: bit0=S, bit1=S1, bit2=S11, bit3=S110, bit4=B0, bit5=B1, bit6=B2, bit7=B3, bit8=Count, bit9=Wait
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // next-state signals
    assign S_next     = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
    assign S1_next    = state[0] & d;
    assign B3_next    = state[6];
    assign Count_next = state[7] | (state[8] & ~done_counting);
    assign Wait_next  = (state[8] & done_counting) | (state[9] & ~ack);

    // outputs from current state (Moore machine)
    assign done      = state[9];
    assign counting  = state[8];
    assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule