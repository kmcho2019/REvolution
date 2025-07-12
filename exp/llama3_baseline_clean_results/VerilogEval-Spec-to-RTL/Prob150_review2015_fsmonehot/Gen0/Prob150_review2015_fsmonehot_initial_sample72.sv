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

// Output logic
assign shift_ena = state[5] | state[4] | state[3] | state[2];
assign counting = state[7];
assign done = state[9];

// Next-state logic
assign B3_next = (state[4] & ~d & 1'b1) | (state[3] & 1'b1);
assign S_next = (state[0] & ~d & 1'b1) | (state[1] & ~d & 1'b1) | (state[8] & ~d & 1'b1) | (state[9] & ack & 1'b1);
assign S1_next = (state[0] & d & 1'b1);
assign Count_next = (state[6] & done_counting & 1'b1) | (state[2] & 1'b1);
assign Wait_next = (state[6] & ~done_counting & 1'b1);

endmodule