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
    wire state0_d = state[0] & d;
    wire state1_nd = state[1] & ~d;
    wire state3_nd = state[3] & ~d;
    wire state9_ack = state[9] & ack;
    wire state8_done = state[8] & done_counting;

    // Optimized next state logic
    assign S_next = (state0_d & ~state[1]) | state1_nd | state3_nd | state9_ack;
    assign S1_next = state0_d;
    assign B3_next = state[6];
    assign Count_next = state[7] | (state[8] & ~done_counting);
    assign Wait_next = state8_done | (state[9] & ~ack);

    // Optimized output logic with balanced OR tree
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = (state[4] | state[5]) | (state[6] | state[7]);  // Balanced OR tree for B0-B3

endmodule