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

    // State group enables
    wire pattern_states = |state[3:0];  // S, S1, S11, S110
    wire shift_states = |state[7:4];    // B0-B3
    wire control_states = |state[9:8];  // Count, Wait

    // Pattern detection transitions
    wire pattern_match = state[3] & d;  // S110 & d=1 -> B0
    wire pattern_reset = (state[1] & ~d) |       // S1 & d=0 -> S
                        (state[2] & ~d) |       // S11 & d=0 -> S110
                        (state[3] & ~d);        // S110 & d=0 -> S

    // Next state logic with hierarchical enables
    assign S_next = (state[0] & ~d) |            // S stays on d=0
                   pattern_reset |               // Pattern reset conditions
                   (state[9] & ack);            // Wait -> S on ack

    assign S1_next = state[0] & d;               // S -> S1 on d=1
    assign B3_next = state[6];                   // B2 -> B3 always

    // Control state transitions with early evaluation
    wire count_complete = state[8] & done_counting;
    wire wait_complete = state[9] & ack;

    assign Count_next = state[7] |               // B3 -> Count
                      (state[8] & ~done_counting); // Count stays

    assign Wait_next = count_complete |          // Count -> Wait
                     (state[9] & ~ack);         // Wait stays

    // Output logic with pipelining
    assign shift_ena = shift_states;             // All shift states
    assign counting = state[8];                  // Count state only
    assign done = state[9];                      // Wait state only

endmodule