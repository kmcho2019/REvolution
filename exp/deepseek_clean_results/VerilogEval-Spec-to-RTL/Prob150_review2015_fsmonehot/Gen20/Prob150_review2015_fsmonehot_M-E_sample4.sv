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

    // Independent next-state condition evaluation for each state
    assign S_next = (state[0] & ~d) |        // S stays on d=0
                    (state[1] & ~d) |        // S1 -> S on d=0
                    (state[3] & ~d) |        // S110 -> S on d=0
                    (state[9] & ack);        // Wait -> S on ack=1

    assign S1_next = (state[0] & d) |        // S -> S1 on d=1
                     (state[1] & d);         // S1 -> S11 on d=1 (but S11 is separate)

    assign B3_next = state[6];               // B2 always goes to B3

    assign Count_next = state[7] |           // B3 always goes to Count
                       (state[8] & ~done_counting);  // Count stays while not done

    assign Wait_next = (state[8] & done_counting) |  // Count -> Wait when done
                       (state[9] & ~ack);            // Wait stays while no ack

    // Output logic - direct from state bits
    assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0-B3
    assign counting = state[8];               // Count state
    assign done = state[9];                   // Wait state

endmodule