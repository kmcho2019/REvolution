module TopModule(
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

// Next-state logic
assign B3_next = (state[8] & ~done_counting);
assign S_next  = (state[3] & ~d) | (state[9] & ack);
assign S1_next = (state[0] & d);
assign Count_next = (state[7] & done_counting);
assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

// Output logic
assign done     = state[9];
assign counting = state[7];
assign shift_ena = state[4] | state[5] | state[6] | state[8];

endmodule