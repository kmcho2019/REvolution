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

    // Next state logic - parallel independent evaluation
    assign S_next = (state[0] & ~d) |                  // S -> S (d=0)
                   (state[1] & ~d) |                   // S1 -> S (d=0)
                   (state[3] & ~d) |                   // S110 -> S (d=0)
                   (state[9] & ack);                   // Wait -> S (ack=1)

    assign S1_next = (state[0] & d);                   // S -> S1 (d=1)

    assign B3_next = state[6];                         // B2 -> B3

    assign Count_next = state[7] |                     // B3 -> Count
                       (state[8] & ~done_counting);    // Count -> Count

    assign Wait_next = (state[8] & done_counting) |    // Count -> Wait
                      (state[9] & ~ack);               // Wait -> Wait

    // Output logic - direct state bit checks
    assign done = state[9];                            // Wait state
    assign counting = state[8];                        // Count state
    assign shift_ena = state[4] | state[5] |           // B0-B3 states
                      state[6] | state[7];

endmodule