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

    // Next state logic - optimized with one-hot properties
    assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
    assign S1_next = state[0] & d;
    assign B3_next = state[6];  // B2 -> B3
    
    // Counting state transitions - shared terms
    wire count_state = state[8];
    assign Count_next = state[7] | (count_state & ~done_counting);
    assign Wait_next = (count_state & done_counting) | (state[9] & ~ack);

    // Output logic - direct and optimized
    assign done = state[9];
    assign counting = count_state;
    assign shift_ena = |state[4:7];  // Single OR for B0-B3 states

endmodule