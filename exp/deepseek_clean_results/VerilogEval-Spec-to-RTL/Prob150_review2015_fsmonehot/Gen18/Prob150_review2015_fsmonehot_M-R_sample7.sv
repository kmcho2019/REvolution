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

    // Next state logic
    assign S_next = (state[0] & ~d) ||        // Stay in S if d=0
                   (state[1] & ~d) ||        // S1->S if d=0
                   (state[3] & ~d) ||        // S110->S if d=0
                   (state[9] & ack);        // Wait->S if ack=1

    assign S1_next = (state[0] & d) ||       // S->S1 if d=1
                    (state[1] & d);          // S1->S11 if d=1 (through S11_next)

    // Shifting states transitions
    assign B3_next = state[6];               // B2->B3 always

    // Counting states transitions
    assign Count_next = state[7] ||          // B3->Count
                       (state[8] & ~done_counting); // Stay in Count

    assign Wait_next = (state[8] & done_counting) || // Count->Wait
                      (state[9] & ~ack);    // Stay in Wait

    // Output logic remains the same as it's optimal
    assign shift_ena = |state[7:4];          // Active in B0-B3 states
    assign counting = state[8];              // Active in Count state
    assign done = state[9];                  // Active in Wait state

endmodule