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

    // Current state decoding - direct wire assignments for minimal delay
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

    // State transition logic - optimized for timing and area
    wire S_from_pattern = (curr_S | curr_S1 | curr_S110) & ~d;
    wire S_from_wait = curr_Wait & ack;
    assign S_next = S_from_pattern | S_from_wait;

    assign S1_next = curr_S & d;

    assign B3_next = curr_B2;  // Single fan-in for best timing

    assign Count_next = curr_B3 | (curr_Count & ~done_counting);

    assign Wait_next = (curr_Count & done_counting) | (curr_Wait & ~ack);

    // Output logic - optimized for power and area
    assign shift_ena = |state[4:7];  // Reduction OR for B0-B3 states
    assign counting = curr_Count;
    assign done = curr_Wait;

endmodule