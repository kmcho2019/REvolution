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
assign S_next = (state[0] & ~d) |      // S->S when d=0
                (state[1] & ~d) |      // S1->S when d=0
                (state[3] & ~d) |      // S110->S when d=0
                (state[9] & ack);      // Wait->S when ack=1

assign S1_next = (state[0] & d) |      // S->S1 when d=1
                 (state[1] & d) |      // S1->S11 when d=1
                 (state[2] & d);       // S11->S11 when d=1

assign B3_next = state[6];             // B2->B3 always

assign Count_next = state[7] |         // B3->Count always
                    (state[8] & ~done_counting); // Count->Count when not done

assign Wait_next = state[8] & done_counting; // Count->Wait when done

// Output logic
assign shift_ena = |state[4:7];        // B0-B3 states
assign counting = state[8];            // Count state
assign done = state[9];                // Wait state

endmodule