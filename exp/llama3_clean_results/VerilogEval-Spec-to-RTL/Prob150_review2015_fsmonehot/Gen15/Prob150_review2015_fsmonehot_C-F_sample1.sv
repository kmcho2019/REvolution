module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Next-state logic equations
    assign B3_next = state[6];  // Direct transition from B2
    assign S_next = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d) || (state[9] && ack);
    assign S1_next = state[0] && d;  // Direct transition
    assign Count_next = state[7] || (state[8] && ~done_counting);  // Reduced redundancy
    assign Wait_next = (state[8] && done_counting) || (state[9] && ~ack);  // Simplified condition

    // Output logic equations
    assign done = state[9];  // Direct assignment
    assign counting = state[8];  // Direct assignment
    assign shift_ena = state[4] || state[5] || state[6] || state[7];  // Simplified condition for shift enable

endmodule