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

    // Next state logic using more structured approach
    assign S_next = (state[0] & ~d) |        // S remains if d=0
                   (state[1] & ~d) |         // S1->S if d=0
                   (state[3] & ~d) |         // S110->S if d=0
                   (state[9] & ack);         // Wait->S if ack=1

    assign S1_next = state[0] & d;           // S->S1 if d=1

    // B state progression (B0->B1->B2->B3->Count)
    assign B3_next = state[6];               // B2->B3 always

    // Count state transitions
    assign Count_next = state[7] |           // B3->Count always
                       (state[8] & ~done_counting); // Count remains if not done

    // Wait state transitions
    assign Wait_next = (state[8] & done_counting) | // Count->Wait when done
                      (state[9] & ~ack);     // Wait remains if no ack

    // Output logic remains functionally identical
    assign done = state[9];                  // Wait state output
    assign counting = state[8];              // Count state output
    assign shift_ena = |state[7:4];          // Any B state (B0-B3)

endmodule