module S_States (
    input  d,
    input  [9:0] state,  // one-hot encoding
    output S_next,
    output S1_next
);

    assign S_next = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d);
    assign S1_next = (state[0] && d);

endmodule

module B_States (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output Count_next,
    output Wait_next
);

    assign B3_next = (state[6] && d) || (state[6] && ~d); // B2 always goes to B3
    assign Count_next = (state[7]) || (state[8] && ~done_counting);
    assign Wait_next = (state[8] && done_counting) || (state[9] && ~ack);

endmodule

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

    S_States s_states (
       .d(d),
       .state(state),
       .S_next(S_next),
       .S1_next(S1_next)
    );

    B_States b_states (
       .d(d),
       .done_counting(done_counting),
       .ack(ack),
       .state(state),
       .B3_next(B3_next),
       .Count_next(Count_next),
       .Wait_next(Wait_next)
    );

    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] || state[5] || state[6] || state[7];

endmodule