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

    // Next state logic optimized for minimal gates
    assign S_next = (state[0] & ~d) |        // S stays on d=0
                   (state[1] & ~d) |        // S1->S on d=0
                   (state[3] & ~d) |        // S110->S on d=0
                   (state[9] & ack);        // Wait->S on ack

    assign S1_next = state[0] & d;          // S->S1 on d=1

    // Bit shifting states - optimized chain
    assign B3_next = state[6];              // B2->B3 always

    // Counting states - optimized conditions
    assign Count_next = state[7] |          // B3->Count always
                       (state[8] & ~done_counting); // Count stays

    assign Wait_next = (state[8] & done_counting) | // Count->Wait
                      (state[9] & ~ack);            // Wait stays

    // Output logic optimized for minimal gates
    assign shift_ena = |state[7:4];         // B0-B3 states
    assign counting = state[8];             // Count state
    assign done = state[9];                 // Wait state

endmodule