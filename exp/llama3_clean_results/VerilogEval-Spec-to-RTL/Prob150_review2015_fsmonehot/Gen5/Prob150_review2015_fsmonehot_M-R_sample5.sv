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
assign B3_next = state[6];
assign S_next  = (~d & (state[0] | state[1] | state[3])) | (ack & state[8]);
assign S1_next = d & state[0];
assign Count_next = state[7] | (~done_counting & state[6]);
assign Wait_next = state[8] | (done_counting & state[7]);

// Output logic using bitwise operations
assign shift_ena = state[4] | state[5] | state[6] | state[7];
assign counting = state[7];
assign done = state[8];

endmodule