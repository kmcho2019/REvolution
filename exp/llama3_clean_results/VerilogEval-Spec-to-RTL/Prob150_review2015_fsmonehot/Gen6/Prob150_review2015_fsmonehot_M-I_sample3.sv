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

// Next-state logic
assign B3_next = (~d & state[3]) | (d & state[2]) | (state[4] & ~d) | (state[5] & ~d) | (state[6] & ~d) | (state[7] & ~done_counting);
assign S_next  = (~d & state[0]) | (~d & state[1]) | (~d & state[3]) | (ack & state[8]);
assign S1_next = (d & state[0]);
assign Count_next = (state[4] & d) | (state[5] & d) | (state[6] & d) | (state[7] & done_counting);
assign Wait_next = (done_counting & state[7]) | (~ack & state[8]);

// Output logic
assign shift_ena = state[4] | state[5] | state[6] | state[7];
assign counting = state[7];
assign done = state[8];

endmodule