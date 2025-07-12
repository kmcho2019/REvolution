module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
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
assign S_next     = (state[0] &&!d) || (state[1] &&!d) || (state[2] &&!d) || (state[3] &&!d);
assign S1_next    = state[0] && d;
assign B3_next    = (state[3] && d) || state[7]; // Transition to B3 from S110 or directly from B3
assign Count_next = state[7] && done_counting; // Transition to Count from B3 when done_counting is high
assign Wait_next  = (state[7] &&!done_counting) || (state[9] && ack); // Transition to Wait from Count when not done_counting, or from Wait when ack

// Output logic equations
assign shift_ena  = state[4] || state[5] || state[6] || state[7]; // Shift enable in B states
assign counting   = state[8]; // Counting in Count state
assign done       = state[9]; // Done in Wait state

endmodule