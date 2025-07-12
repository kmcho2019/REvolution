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

    // Corrected and optimized next state logic
    assign S_next = (state[0] & ~d) |        // S stays on d=0
                   (state[1] & ~d) |         // S1->S on d=0
                   (state[3] & ~d) |         // S110->S on d=0
                   (state[9] & ack);         // Wait->S on ack=1

    assign S1_next = state[0] & d;           // Only S->S1 on d=1

    assign B3_next = state[6];               // B2 always goes to B3

    assign Count_next = state[7] |           // B3->Count
                       (state[8] & ~done_counting); // Count stays if not done

    assign Wait_next = (state[8] & done_counting) | // Count->Wait when done
                      (state[9] & ~ack);     // Wait stays if no ack

    // Output logic (unchanged, was correct)
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[7:4];          // Any B state (B0-B3)

endmodule