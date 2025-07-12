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

// Next-state logic indicators
assign B3_next = (state[6] && d) || (state[5] && d) || (state[4] && d) || (state[3] && d);
assign S_next = (state[0] && !d) || (state[1] && !d) || (state[2] && !d) || (state[7] && done_counting) || (state[9] && ack);
assign S1_next = state[0] && d;
assign Count_next = state[5] && !d;
assign Wait_next = state[7] && !done_counting;

// Output logic
assign shift_ena = state[3] || state[4] || state[5] || state[6];
assign counting = state[7];
assign done = state[9];

endmodule