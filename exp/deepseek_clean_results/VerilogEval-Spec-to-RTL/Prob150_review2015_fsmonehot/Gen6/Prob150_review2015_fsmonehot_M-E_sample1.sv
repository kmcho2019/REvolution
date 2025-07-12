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

    // Current state decoding (one-hot)
    wire [9:0] curr_state = state;

    // Next state logic with priority encoding
    assign S_next = (curr_state[0] & ~d) |          // S->S when d=0
                   (curr_state[1] & ~d) |          // S1->S when d=0
                   (curr_state[3] & ~d) |          // S110->S when d=0
                   (curr_state[9] & ack);          // Wait->S when ack=1

    assign S1_next = (curr_state[0] & d) &          // S->S1 when d=1
                    ~(curr_state[9] & ack);         // Priority over Wait->S

    wire S11_next = (curr_state[1] & d);            // S1->S11 when d=1

    wire S110_next = (curr_state[2] & ~d);          // S11->S110 when d=0

    // B-state sequence treated as a shift operation
    wire B0_next = (curr_state[3] & d);             // S110->B0 when d=1
    wire B1_next = curr_state[4];                   // B0->B1
    wire B2_next = curr_state[5];                   // B1->B2
    assign B3_next = curr_state[6];                 // B2->B3

    // Count state with priority
    assign Count_next = curr_state[7] |             // B3->Count
                       (curr_state[8] & ~done_counting); // Count->Count when not done

    // Wait state with priority
    assign Wait_next = (curr_state[8] & done_counting) | // Count->Wait when done
                      (curr_state[9] & ~ack);       // Wait->Wait when no ack

    // Output logic - direct state decodes
    assign shift_ena = |curr_state[4:7];           // B0-B3 states
    assign counting = curr_state[8];               // Count state
    assign done = curr_state[9];                   // Wait state

endmodule