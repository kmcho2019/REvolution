module NextStateLogic (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next
);

    assign B3_next = state[6]; // B2 always goes to B3
    assign S_next = (state[0] && ~d) || (state[1] && ~d) || (state[3] && ~d) || (state[9] && ack);
    assign S1_next = state[0] && d;
    assign Count_next = state[7] || (state[8] && ~done_counting);
    assign Wait_next = state[8] && done_counting || (state[9] && ~ack);

endmodule

module OutputLogic (
    input  [9:0] state,  // one-hot encoding
    output done,
    output counting,
    output shift_ena
);

    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = state[4] || state[5] || state[6] || state[7];

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

    NextStateLogic next_state_logic (.d(d), .done_counting(done_counting), .ack(ack), .state(state), .B3_next(B3_next), .S_next(S_next), .S1_next(S1_next), .Count_next(Count_next), .Wait_next(Wait_next));

    OutputLogic output_logic (.state(state), .done(done), .counting(counting), .shift_ena(shift_ena));

endmodule