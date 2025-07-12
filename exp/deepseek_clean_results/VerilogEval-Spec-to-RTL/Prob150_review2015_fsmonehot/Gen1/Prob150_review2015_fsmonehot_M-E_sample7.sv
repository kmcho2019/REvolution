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

    // Current state decoding
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

    // Next state logic - computed in parallel
    assign S_next = (S_curr & ~d) |                // S stays on d=0
                   (S1_curr & ~d) |               // S1->S on d=0
                   (S110_curr & ~d) |             // S110->S on d=0
                   (Wait_curr & ack);             // Wait->S on ack=1

    assign S1_next = (S_curr & d) |               // S->S1 on d=1
                    (S1_curr & d & ~S11_curr);    // S1->S1 on d=1 (but not from S11)

    assign B3_next = B2_curr;                     // B2 always goes to B3

    assign Count_next = B3_curr;                  // B3 always goes to Count

    assign Wait_next = Count_curr & done_counting; // Count->Wait when done_counting

    // Output logic (unchanged from original)
    assign done = Wait_curr;
    assign counting = Count_curr;
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;

endmodule