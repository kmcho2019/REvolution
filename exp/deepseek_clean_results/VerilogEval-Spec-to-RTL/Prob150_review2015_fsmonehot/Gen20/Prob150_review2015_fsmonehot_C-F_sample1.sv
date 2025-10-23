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

    // Optimized next state logic - fused from both examples
    assign S_next = (~d & (state[0] | state[1] | state[3])) |  // S/S1/S110->S when d=0
                    (state[9] & ack);                          // Wait->S when ack=1

    assign S1_next = state[0] & d;         // S->S1 when d=1

    assign B3_next = state[6];             // B2->B3 always

    assign Count_next = state[7] |         // B3->Count always
                       (state[8] & ~done_counting); // Count stays

    assign Wait_next = state[8] & done_counting |  // Count->Wait when done
                      (state[9] & ~ack);           // Wait stays

    // Optimized output logic - best of both examples
    assign shift_ena = |state[7:4];        // B0-B3 states (OR reduction)
    assign counting = state[8];            // Count state
    assign done = state[9];                // Wait state

endmodule