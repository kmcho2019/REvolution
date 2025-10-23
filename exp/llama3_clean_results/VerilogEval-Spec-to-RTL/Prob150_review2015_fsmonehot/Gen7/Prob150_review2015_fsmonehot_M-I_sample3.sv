module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Next-state logic using bitwise operations
assign B3_next = (state[2] & d); // B3 is only reachable from B2
assign S_next  = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[8] & ack);
assign S1_next = (state[0] & d);
assign Count_next = (state[4] & d); // Count is only reachable from B3
assign Wait_next = (state[7] & done_counting); // Wait is only reachable from Count when done_counting is 1

// Output logic using bitwise operations
assign shift_ena = state[4] | state[5] | state[6] | state[7]; // shift_ena is 1 in states B0, B1, B2, B3, Count
assign counting = state[7]; // counting is 1 only in state Count
assign done = state[8]; // done is 1 only in state Wait

endmodule