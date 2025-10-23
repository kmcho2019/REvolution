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

// Next-state logic
assign B3_next = (state[3] & ~d) | (state[2] & ~d) | (state[1] & ~d) | (state[0] & ~d) | (state[4] & ~done_counting);
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
assign S1_next = (state[0] & d) | (state[1] & ~d);
assign Count_next = (state[4] & done_counting);
assign Wait_next = (state[8] | (state[4] & done_counting));

// Output logic
assign shift_ena = state[5] | state[6] | state[7] | state[3];
assign counting = state[4];
assign done = state[8];

endmodule