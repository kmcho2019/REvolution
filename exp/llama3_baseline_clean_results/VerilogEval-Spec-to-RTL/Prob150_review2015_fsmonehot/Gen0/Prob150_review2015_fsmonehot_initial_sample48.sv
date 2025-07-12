module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state, // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // next-state logic
    assign S_next = (state[0] && !d) || (state[1] && !d) || (state[3] && !d) || (state[9] && ack);
    assign S1_next = state[0] && d;
    assign Count_next = state[8] || (state[7] && done_counting);
    assign Wait_next = state[8] && !done_counting;
    assign B3_next = state[6];

    // output logic
    assign shift_ena = state[5] || state[6] || state[7] || state[4];
    assign counting = state[8];
    assign done = state[9];

endmodule