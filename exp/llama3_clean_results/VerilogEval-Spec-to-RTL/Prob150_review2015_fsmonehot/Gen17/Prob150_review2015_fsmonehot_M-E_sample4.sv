module TopModule (
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

    // Next-state logic equations using a unified block
    wire [9:0] next_state;
    assign next_state[0] = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d) || (state[9] && ack);
    assign next_state[1] = (state[0] && d);
    assign next_state[2] = (state[1] && d);
    assign next_state[3] = (state[2] && ~d);
    assign next_state[4] = (state[3] && d);
    assign next_state[5] = (state[4]);
    assign next_state[6] = (state[5]);
    assign next_state[7] = (state[6]) || (state[8] && ~done_counting);
    assign next_state[8] = (state[7]);
    assign next_state[9] = (state[8] && done_counting) || (state[9] && ~ack);

    // Output logic equations using a decoder
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] || state[5] || state[6] || state[7];

    // Next-state signals
    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

endmodule