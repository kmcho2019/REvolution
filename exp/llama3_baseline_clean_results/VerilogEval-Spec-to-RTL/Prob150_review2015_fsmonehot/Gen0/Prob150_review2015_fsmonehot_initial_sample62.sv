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
    assign B3_next = (state[1] && d) || (state[2] && d) || (state[3] && d) || (state[4] && 1'b1) || (state[5] && 1'b1) || (state[6] && 1'b1) || (state[7] && 1'b1);
    assign S_next = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d) || (state[8] && ack);
    assign S1_next = (state[0] && d);
    assign Count_next = (state[5] && 1'b1) || (state[6] && 1'b1) || (state[7] && 1'b1) || (state[9] && ~done_counting);
    assign Wait_next = (state[7] && 1'b1) || (state[9] && ~ack);

    // Output logic
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] || state[5] || state[6] || state[7];

endmodule