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

    // Next state logic with optimized parallel paths
    assign S_next = (state[0] & ~d) |        // S stay or S->S
                   (state[1] & ~d) |        // S1->S
                   (state[3] & ~d) |        // S110->S
                   (state[9] & ack);        // Wait->S

    assign S1_next = state[0] & d;          // S->S1
    assign B3_next = state[6];              // B2->B3
    assign Count_next = state[7] |          // B3->Count
                       (state[8] & ~done_counting); // Count stay
    assign Wait_next = state[8] & done_counting; // Count->Wait

    // Output logic - direct from state bits
    assign shift_ena = |state[7:4];         // B0-B3 states
    assign counting = state[8];             // Count state
    assign done = state[9];                 // Wait state

endmodule