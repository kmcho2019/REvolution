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

    // State bit aliases for clarity
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // Next state logic
    assign S_next = (S & ~d) |        // S->S when d=0
                   (S1 & ~d) |        // S1->S when d=0
                   (S110 & ~d) |      // S110->S when d=0
                   (Wait & ack);      // Wait->S when ack=1

    assign S1_next = (S & d);         // S->S1 when d=1

    assign B3_next = B2;              // B2->B3 always

    assign Count_next = B3 |          // B3->Count always
                       (Count & ~done_counting); // Count->Count when done_counting=0

    assign Wait_next = Count & done_counting; // Count->Wait when done_counting=1

    // Output logic
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 | B1 | B2 | B3; // B0-B3 states

endmodule