module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // One-hot encoding: S, S1, S11, S110, B0, B1, B2, B3, Count, Wait
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Next-state logic
assign B3_next = (state[5] && d);  // B2 and d=1
assign S_next = (state[3] && !d) || (state[9] && ack);  // S110 with d=0 or Wait with ack=1
assign S1_next = (state[0] && d) || (state[1] && !d);  // S with d=1 or S1 with d=0
assign Count_next = (state[4] && done_counting);  // B3 and done_counting=1
assign Wait_next = (state[8] && !done_counting);  // Count with done_counting=0

// Output logic
assign shift_ena = state[4] || state[5] || state[6] || state[7];  // B0, B1, B2, or B3
assign counting = state[8];  // Count
assign done = state[9];  // Wait

endmodule