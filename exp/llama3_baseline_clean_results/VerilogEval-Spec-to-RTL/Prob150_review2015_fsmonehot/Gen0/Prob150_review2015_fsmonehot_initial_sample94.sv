module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // One-hot encoding for states
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
assign B3_next = state[6]; // B3 is the 7th state in one-hot encoding (counting from 0)
assign S_next = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack); // S is the 0th state
assign S1_next = state[0] && d; // S1 is the 1st state
assign Count_next = state[7]; // Count is the 8th state
assign Wait_next = state[9]; // Wait is the 9th state

// Output logic
assign shift_ena = state[4] || state[5] || state[6] || state[7]; // States B0, B1, B2, B3 have shift_ena = 1
assign counting = state[7]; // Only Count state has counting = 1
assign done = state[9]; // Only Wait state has done = 1

endmodule