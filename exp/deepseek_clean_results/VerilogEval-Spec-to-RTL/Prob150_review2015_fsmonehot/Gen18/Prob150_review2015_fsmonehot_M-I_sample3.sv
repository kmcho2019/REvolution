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

    // Next state logic - optimized expressions
    assign S_next = (state[0] & ~d) |       // S->S when d=0
                   (state[1] & ~d) |       // S1->S when d=0
                   (state[3] & ~d) |       // S110->S when d=0
                   (state[9] & ack);       // Wait->S when ack=1

    assign S1_next = state[0] & d;         // S->S1 when d=1

    assign B3_next = state[6];             // B2->B3 always

    assign Count_next = state[7] |         // B3->Count always
                       (state[8] & ~done_counting); // Count->Count when not done

    assign Wait_next = (state[8] & done_counting) | // Count->Wait when done
                      (state[9] & ~ack);           // Wait->Wait when no ack

    // Output logic - optimized
    assign shift_ena = state[4] | state[5] | state[6] | state[7]; // B0-B3 states
    assign counting = state[8];           // Count state
    assign done = state[9];               // Wait state

endmodule