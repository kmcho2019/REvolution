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

    // Next-state logic using direct state bit comparisons
    assign S_next = (~d & (state[0] | state[1] | state[3])) |  // S, S1, S110 conditions
                    (state[9] & ack);                           // Wait -> S transition

    assign S1_next = state[0] & d;                              // S -> S1 transition

    assign B3_next = state[6];                                  // B2 -> B3 transition

    assign Count_next = state[7] |                              // B3 -> Count transition
                       (state[8] & ~done_counting);             // Count -> Count condition

    assign Wait_next = (state[8] & done_counting) |             // Count -> Wait transition
                      (state[9] & ~ack);                        // Wait -> Wait condition

    // Output logic - direct from state bits
    assign shift_ena = |state[7:4];                            // B0-B3 states
    assign counting = state[8];                                 // Count state
    assign done = state[9];                                     // Wait state

endmodule