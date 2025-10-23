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
assign done = state[9]; // Wait state
assign counting = state[8]; // Count state
assign shift_ena = state[5] | state[6] | state[7] | state[4]; // B0, B1, B2, B3 states

// Next-state logic
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[2] & ~d) | (state[3] & ~d);
assign S1_next = state[0] & d;
assign Count_next = state[4];
assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);
assign B3_next = state[4];

endmodule