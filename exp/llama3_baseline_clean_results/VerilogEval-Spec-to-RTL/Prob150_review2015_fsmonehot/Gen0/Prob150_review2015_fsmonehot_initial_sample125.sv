module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding of states
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
assign B3_next = (state[8] & 1'b1);  // next state is B3
assign S_next = ((state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack));  // next state is S
assign S1_next = (state[0] & d);  // next state is S1
assign Count_next = (state[7] & done_counting);  // next state is Count
assign Wait_next = (state[7] & ~done_counting);  // next state is Wait

// Output logic
assign shift_ena = (state[4] | state[5] | state[6] | state[8]);  // shift_ena is 1 in states B0, B1, B2, B3
assign counting = state[7];  // counting is 1 in state Count
assign done = state[9];  // done is 1 in state Wait

endmodule