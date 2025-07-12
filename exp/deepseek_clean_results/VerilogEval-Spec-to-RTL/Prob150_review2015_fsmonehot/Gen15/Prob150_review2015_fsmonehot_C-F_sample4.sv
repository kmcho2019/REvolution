module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: S(0), S1(1), S11(2), S110(3),
                        // B0(4), B1(5), B2(6), B3(7), Count(8), Wait(9)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Pattern detection states (S, S1, S11, S110)
    wire pattern_states = |state[3:0];
    assign S_next = (state[0] & ~d) |         // S stays on d=0
                   (state[1] & ~d) |         // S1->S on d=0
                   (state[3] & ~d) |         // S110->S on d=0
                   (state[9] & ack);         // Wait->S on ack=1
    assign S1_next = state[0] & d;           // S->S1 on d=1

    // Shifting states (B0-B3)
    assign B3_next = state[6];               // B2->B3 always

    // Counting states (Count, Wait)
    assign Count_next = state[7] |           // B3->Count
                       (state[8] & ~done_counting);  // Count stays
    assign Wait_next = (state[8] & done_counting) |  // Count->Wait
                      (state[9] & ~ack);     // Wait stays

    // Output logic - direct from state bits
    assign shift_ena = |state[7:4];          // B0-B3 (shift states)
    assign counting = state[8];              // Count state
    assign done = state[9];                  // Wait state

endmodule