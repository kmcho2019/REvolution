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

    assign shift_ena = state[5] | state[4] | state[3] | state[2];  // B0, B1, B2, B3 states
    assign counting = state[7];  // Count state
    assign done = state[8];  // Wait state

    assign B3_next = (state[0] && d) || (state[1] && d && !d) || (state[2] && d && !d) || (state[3] && !d) || state[4];
    assign S_next = (state[0] && !d) || (state[1] && !d) || (state[6] && !d) || (state[8] && ack);
    assign S1_next = (state[0] && d);
    assign Count_next = (state[6] && done_counting);
    assign Wait_next = (state[7] && done_counting);

endmodule