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

    // Current state bits (one-hot encoding)
    wire S_curr    = state[0];
    wire S1_curr   = state[1];
    wire S11_curr  = state[2];
    wire S110_curr = state[3];
    wire B0_curr   = state[4];
    wire B1_curr   = state[5];
    wire B2_curr   = state[6];
    wire B3_curr   = state[7];
    wire Count_curr= state[8];
    wire Wait_curr = state[9];

    // Next state logic - each output represents entering that state next
    assign S_next = (S_curr & ~d) |         // Stay in S if d=0
                    (S1_curr & ~d) |        // Return to S from S1 if d=0
                    (S110_curr & ~d) |      // Return to S from S110 if d=0
                    (Wait_curr & ack);      // Return to S from Wait if ack=1

    assign S1_next = S_curr & d;           // S->S1 if d=1

    assign B3_next = B2_curr;               // B2 always goes to B3

    assign Count_next = B3_curr |           // B3->Count
                        (Count_curr & ~done_counting); // Stay in Count if not done

    assign Wait_next = (Count_curr & done_counting) | // Count->Wait if done
                       (Wait_curr & ~ack);  // Stay in Wait if no ack

    // Output logic (Moore-style)
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule