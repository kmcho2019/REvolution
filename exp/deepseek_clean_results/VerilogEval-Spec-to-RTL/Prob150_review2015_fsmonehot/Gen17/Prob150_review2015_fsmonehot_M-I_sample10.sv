module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Common terms
    wire s0_d0 = state[0] & ~d;
    wire s1_d0 = state[1] & ~d;
    wire s3_d0 = state[3] & ~d;
    wire s9_ack = state[9] & ack;

    // Next state logic
    assign S_next = s0_d0 | s1_d0 | s3_d0 | s9_ack;
    assign S1_next = state[0] & d;
    assign B3_next = state[6];
    assign Count_next = state[7] ? ~done_counting : state[8] & ~done_counting;
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

    // Output logic
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0-B3 states

endmodule