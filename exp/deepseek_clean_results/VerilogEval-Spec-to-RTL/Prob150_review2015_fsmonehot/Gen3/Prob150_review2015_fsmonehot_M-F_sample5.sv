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

// One-hot encoded state definitions
parameter S      = 0;
parameter S1     = 1;
parameter S11    = 2;
parameter S110   = 3;
parameter B0     = 4;
parameter B1     = 5;
parameter B2     = 6;
parameter B3     = 7;
parameter Count  = 8;
parameter Wait   = 9;

// Next state logic
assign S_next = (state[S] & ~d) |        // S stays when d=0
                (state[S1] & ~d) |       // S1->S when d=0
                (state[S110] & ~d) |     // S110->S when d=0
                (state[Wait] & ack);     // Wait->S when ack=1

assign S1_next = (state[S] & d) |        // S->S1 when d=1
                 (state[S1] & d);        // S1->S11 when d=1
                 // Removed incorrect S11->S11 transition

assign B3_next = state[B2];              // B2->B3 always

assign Count_next = state[B3] |          // B3->Count always
                    (state[Count] & ~done_counting); // Count stays when not done

assign Wait_next = state[Count] & done_counting; // Count->Wait when done

// Output logic
assign shift_ena = |state[7:4];          // B0-B3 states
assign counting = state[Count];          // Count state
assign done = state[Wait];               // Wait state

endmodule