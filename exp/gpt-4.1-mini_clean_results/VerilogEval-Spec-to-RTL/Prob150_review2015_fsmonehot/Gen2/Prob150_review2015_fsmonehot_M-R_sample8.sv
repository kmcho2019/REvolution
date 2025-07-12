module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // One-hot: bit0=S, bit1=S1, ..., bit9=Wait
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // S_next: from S(d=0), S1(d=0), S110(d=0), or Wait(ack=1)
    assign S_next = (state[0] & ~d)             // S to S
                  | (state[1] & ~d)             // S1 to S
                  | (state[3] & ~d)             // S110 to S
                  | (state[9] & ack);           // Wait to S

    // S1_next: from S(d=1)
    assign S1_next = state[0] & d;

    // B3_next: from B2 (always next)
    assign B3_next = state[6];

    // Count_next: from B3 or Count(done_counting=0)
    assign Count_next = state[7]                  // B3 to Count
                      | (state[8] & ~done_counting); // stay in Count

    // Wait_next: from Count(done_counting=1) or Wait(ack=0)
    assign Wait_next = (state[8] & done_counting) // Count to Wait
                     | (state[9] & ~ack);          // stay in Wait

    // done output: high in Wait
    assign done = state[9];

    // counting output: high in Count
    assign counting = state[8];

    // shift_ena output: high in B0,B1,B2,B3 states
    assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule