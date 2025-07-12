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

    // Direct state bit access
    wire S_state = state[0];
    wire S1_state = state[1];
    wire S110_state = state[3];
    wire B2_state = state[6];
    wire B3_state = state[7];
    wire Count_state = state[8];
    wire Wait_state = state[9];

    // Optimized next-state logic
    assign S_next = (S_state & ~d) |        // S stays on d=0
                   (S1_state & ~d) |       // S1->S on d=0
                   (S110_state & ~d) |     // S110->S on d=0
                   (Wait_state & ack);     // Wait->S on ack

    assign S1_next = S_state & d;          // S->S1 on d=1
    assign B3_next = B2_state;             // B2->B3 always
    assign Count_next = B3_state |         // B3->Count
                       (Count_state & ~done_counting);
    assign Wait_next = (Count_state & done_counting) | // Count->Wait
                       (Wait_state & ~ack);

    // Optimized output logic
    assign shift_ena = |state[7:4];       // B0-B3 states
    assign counting = Count_state;        // Only Count state
    assign done = Wait_state;             // Only Wait state

endmodule