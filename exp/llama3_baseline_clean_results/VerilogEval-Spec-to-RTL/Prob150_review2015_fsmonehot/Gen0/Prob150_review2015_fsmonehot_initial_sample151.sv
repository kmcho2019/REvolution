module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // one-hot encoding
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
assign S_next = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
assign S1_next = state[0] && d;
assign B3_next = state[7]; // B3 state
assign Count_next = (state[8] && done_counting) || state[6]; // Count state
assign Wait_next = (state[8] && !done_counting) || (state[9] && !ack);

// Output logic
assign shift_ena = state[4] || state[5] || state[6] || state[7]; // B0, B1, B2, B3 states
assign counting = state[8]; // Count state
assign done = state[9]; // Wait state

endmodule