module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: S(0), S1(1), S11(2), S110(3),
                        // B0(4), B1(5), B2(6), B3(7), Count(8), Wait(9)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Pattern detection state transitions
    wire s_stays      = state[0] & ~d;
    wire s1_to_s      = state[1] & ~d;
    wire s110_to_s    = state[3] & ~d;
    wire wait_to_s    = state[9] & ack;
    assign S_next     = s_stays | s1_to_s | s110_to_s | wait_to_s;
    
    assign S1_next    = state[0] & d;  // S->S1 on d=1

    // Shifting state transitions
    assign B3_next    = state[6];      // B2->B3 always

    // Counting state transitions
    wire count_holds  = state[8] & ~done_counting;
    assign Count_next = state[7] | count_holds;  // B3->Count or hold
    
    wire wait_holds   = state[9] & ~ack;
    assign Wait_next  = (state[8] & done_counting) | wait_holds;

    // Output logic
    assign shift_ena = |state[7:4];    // B0-B3 states
    assign counting  = state[8];       // Count state
    assign done      = state[9];       // Wait state

endmodule