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

    // Current state decoding - direct bit selects for minimal delay
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

    // Optimized state transition logic
    assign S_next = (curr_S | curr_S1 | curr_S110) & ~d |  // Pattern detection states -> S
                   (curr_Wait & ack);                     // Wait -> S on ack

    assign S1_next = curr_S & d;                          // S -> S1 on d=1

    // Bit shifting states - simple linear progression
    assign B3_next = curr_B2;

    // Counting states - optimized logic
    assign Count_next = curr_B3 | (curr_Count & ~done_counting);

    assign Wait_next = (curr_Count & done_counting) | (curr_Wait & ~ack);

    // Optimized output logic
    assign shift_ena = |state[4:7];  // Reduction OR for B0-B3 states
    assign counting = curr_Count;
    assign done = curr_Wait;

endmodule