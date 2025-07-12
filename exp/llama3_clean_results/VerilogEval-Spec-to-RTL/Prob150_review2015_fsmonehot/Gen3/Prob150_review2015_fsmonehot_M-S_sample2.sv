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

// Next-state logic equations
assign B3_next = state[5]; // B3 state is next when current state is B2
assign S_next  = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
assign S1_next = (state[0] && d) || (state[1] && !d);
assign Count_next = state[4]; // Count state is next when current state is B3
assign Wait_next = (state[7] && done_counting);

// Output logic equations
assign shift_ena = state[4] || state[5] || state[6] || state[7];
assign counting = state[7];
assign done    = state[8];

endmodule