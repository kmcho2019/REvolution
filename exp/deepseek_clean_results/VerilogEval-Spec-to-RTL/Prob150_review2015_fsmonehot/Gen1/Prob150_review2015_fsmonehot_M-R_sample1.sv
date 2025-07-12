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

// State definitions (one-hot encoding)
parameter S      = 10'b0000000001;
parameter S1     = 10'b0000000010;
parameter S11    = 10'b0000000100;
parameter S110   = 10'b0000001000;
parameter B0     = 10'b0000010000;
parameter B1     = 10'b0000100000;
parameter B2     = 10'b0001000000;
parameter B3     = 10'b0010000000;
parameter Count  = 10'b0100000000;
parameter Wait   = 10'b1000000000;

// Next state logic
assign S_next = (state[S] & ~d) |        // S->S when d=0
                (state[S1] & ~d) |       // S1->S when d=0
                (state[S110] & ~d) |     // S110->S when d=0
                (state[Wait] & ack);     // Wait->S when ack=1

assign S1_next = (state[S] & d) |        // S->S1 when d=1
                 (state[S1] & d) |       // S1->S1 when d=1
                 (state[S11] & d);       // S11->S11 when d=1

assign B3_next = state[B2];              // B2->B3 always

assign Count_next = state[B3] |          // B3->Count always
                    (state[Count] & ~done_counting); // Count->Count when not done

assign Wait_next = state[Count] & done_counting; // Count->Wait when done

// Output logic (unchanged as it was correct)
assign shift_ena = |state[B0:B3];        // OR of B0-B3 states
assign counting = state[Count];
assign done = state[Wait];

endmodule