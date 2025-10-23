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

    // Next state logic
    assign S_next = (state[0] & ~d) |         // Stay in S if d=0
                   (state[1] & ~d) |         // S1 to S if d=0
                   (state[3] & ~d) |         // S110 to S if d=0
                   (state[9] & ack);         // Wait to S if ack=1

    assign S1_next = state[0] & d;           // S to S1 if d=1

    assign B3_next = state[6];               // B2 always goes to B3

    assign Count_next = state[7] |           // B3 to Count
                        (state[8] & ~done_counting); // Stay in Count if not done

    assign Wait_next = (state[8] & done_counting) |  // Count to Wait if done
                      (state[9] & ~ack);     // Stay in Wait if no ack

    // Output logic
    assign shift_ena = |state[4:7];          // B0-B3 states
    assign counting = state[8];              // Count state
    assign done = state[9];                  // Wait state

endmodule