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
assign B3_next = (state[8] && d) || (state[7] && d) || (state[6] && d) || (state[5] && d);
assign S_next = (state[9] && !d) || (state[1] && !d) || (state[2] && !d);
assign S1_next = (state[0] && d);
assign Count_next = (state[4] && done_counting);
assign Wait_next = (state[4] && !done_counting) || (state[3] && ack);

// Output logic
assign done = state[3];
assign counting = state[4];
assign shift_ena = state[5] || state[6] || state[7] || state[8];

endmodule