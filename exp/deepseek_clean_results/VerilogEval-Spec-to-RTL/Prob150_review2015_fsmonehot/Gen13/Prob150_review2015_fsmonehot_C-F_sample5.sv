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

    // Current state decoding with descriptive names
    wire curr_S     = state[0];
    wire curr_S1    = state[1];
    wire curr_S11   = state[2];
    wire curr_S110  = state[3];
    wire curr_B0    = state[4];
    wire curr_B1    = state[5];
    wire curr_B2    = state[6];
    wire curr_B3    = state[7];
    wire curr_Count = state[8];
    wire curr_Wait  = state[9];

    // State transition logic
    // Pattern detection states
    assign S_next = (curr_S & ~d) |          // S stays on d=0
                   (curr_S1 & ~d) |         // S1->S on d=0
                   (curr_S110 & ~d) |       // S110->S on d=0
                   (curr_Wait & ack);      // Wait->S on ack=1

    assign S1_next = curr_S & d;            // S->S1 on d=1

    // Bit shifting states
    assign B3_next = curr_B2;               // B2->B3 always

    // Counting states
    assign Count_next = curr_B3 |           // B3->Count always
                       (curr_Count & ~done_counting); // Count stays until done

    assign Wait_next = (curr_Count & done_counting) | // Count->Wait when done
                      (curr_Wait & ~ack);            // Wait stays until ack

    // Output logic
    assign shift_ena = curr_B0 | curr_B1 | curr_B2 | curr_B3; // All shifting states
    assign counting = curr_Count;
    assign done = curr_Wait;

endmodule