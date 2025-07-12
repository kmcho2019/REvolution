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
    wire current_S     = state[0];
    wire current_S1    = state[1];
    wire current_S11   = state[2];
    wire current_S110  = state[3];
    wire current_B0    = state[4];
    wire current_B1    = state[5];
    wire current_B2    = state[6];
    wire current_B3    = state[7];
    wire current_Count = state[8];
    wire current_Wait  = state[9];

    // Next state logic organized by destination state
    assign S_next = (current_S & ~d) |          // S stays on d=0
                   (current_S1 & ~d) |         // S1 -> S on d=0
                   (current_S110 & ~d) |       // S110 -> S on d=0
                   (current_Wait & ack);      // Wait -> S on ack=1

    assign S1_next = current_S & d;            // S -> S1 on d=1

    assign B3_next = current_B2;               // B2 always -> B3

    assign Count_next = current_B3 |           // B3 -> Count
                       (current_Count & ~done_counting); // Count stays until done

    assign Wait_next = (current_Count & done_counting) | // Count -> Wait when done
                      (current_Wait & ~ack);   // Wait stays until ack

    // Output logic (Moore style - depends only on current state)
    assign shift_ena = current_B0 | current_B1 | current_B2 | current_B3;
    assign counting  = current_Count;
    assign done      = current_Wait;

endmodule