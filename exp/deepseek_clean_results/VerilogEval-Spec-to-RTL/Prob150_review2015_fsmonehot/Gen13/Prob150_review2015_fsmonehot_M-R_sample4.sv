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

    // State decoding (one-hot)
    wire [9:0] current_state = state;

    // Next state logic
    assign S_next = (current_state[0] & ~d) |        // S -> S (d=0)
                   (current_state[1] & ~d) |        // S1 -> S (d=0)
                   (current_state[3] & ~d) |        // S110 -> S (d=0)
                   (current_state[9] & ack);       // Wait -> S (ack=1)

    assign S1_next = current_state[0] & d;          // S -> S1 (d=1)

    assign B3_next = current_state[6];              // B2 -> B3

    assign Count_next = current_state[7] |          // B3 -> Count
                       (current_state[8] & ~done_counting); // Count -> Count

    assign Wait_next = (current_state[8] & done_counting) | // Count -> Wait
                      (current_state[9] & ~ack);    // Wait -> Wait

    // Output logic
    assign done = current_state[9];                 // Wait state
    assign counting = current_state[8];             // Count state
    assign shift_ena = |current_state[6:4];         // B0-B3 states

endmodule