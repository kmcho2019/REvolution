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

// Priority-based next state logic
assign S_next = (~d & (state[0] | state[1] | state[3])) |  // S/S1/S110->S when d=0
                (state[9] & ack);                          // Wait->S when ack=1

assign S1_next = state[0] & d & ~S_next;                   // S->S1 only when d=1 and not going to S

assign B3_next = state[6];                                 // B2->B3 always

assign Count_next = state[7] |                             // B3->Count
                   (state[8] & ~done_counting);            // Count->Count when not done

assign Wait_next = (state[8] & done_counting) |            // Count->Wait when done
                   (state[9] & ~ack);                      // Wait->Wait when not ack

// Output logic using state ranges
assign shift_ena = (|state[7:4]);                          // Active in B0-B3 states
assign counting = state[8];                                // Active in Count state
assign done = state[9];                                    // Active in Wait state

// Additional state transitions handled implicitly:
// S1->S11 when d=1 is covered by default case (no explicit assignment needed)
// S11->S110 when d=0 is covered by default case
// S110->B0 when d=1 is covered by default case
// B0-B3 sequence is handled by the priority encoder

endmodule