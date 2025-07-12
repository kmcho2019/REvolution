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

    // State group signals
    wire pattern_states = |state[3:0];      // S, S1, S11, S110
    wire shifting_states = |state[7:4];     // B0-B3
    wire control_states = |state[9:8];      // Count, Wait

    // Pattern detection state transitions
    assign S_next = (state[0] & ~d) |       // S stays on d=0
                   (state[1] & ~d) |       // S1->S on d=0
                   (state[3] & ~d) |        // S110->S on d=0
                   (state[9] & ack);        // Wait->S on ack

    assign S1_next = (state[0] & d) |       // S->S1 on d=1
                    (state[2] & d);         // S11->S11 on d=1 (but S11 stays)

    // Shifting state transitions (implicit progression)
    assign B3_next = state[6];              // B2->B3 always

    // Control state transitions
    assign Count_next = state[7] |          // B3->Count always
                       (state[8] & ~done_counting); // Count stays until done

    assign Wait_next = (state[8] & done_counting) | // Count->Wait when done
                      (state[9] & ~ack);            // Wait stays until ack

    // Output logic using state groups
    assign shift_ena = shifting_states;     // All shifting states enable shift
    assign counting = state[8];             // Only Count state sets counting
    assign done = state[9];                 // Only Wait state sets done

endmodule