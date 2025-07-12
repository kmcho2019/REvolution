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

// One-hot encoding:
// (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
// = (10'b0000000001, 10'b0000000010, 10'b0000000100, ... , 10'b1000000000)

// Next-state logic
assign B3_next = (state[5] & ~done_counting) | (state[6] & ~done_counting) | (state[7] & ~done_counting);
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
assign S1_next = state[0] & d;
assign Count_next = state[8] & done_counting;
assign Wait_next = state[8] & ~done_counting & ~state[9] | (state[9] & ~ack);

// Output logic
assign done = state[9];
assign counting = state[8];
assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule