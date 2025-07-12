module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // one-hot encoding
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
assign B3_next = (state[6] & 1'b1); // next state is B3 when current state is B2
assign S_next = ((state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack)); // next state is S when current state is S and d=0, or S1 and d=0, or S110 and d=0, or Wait and ack=1
assign S1_next = (state[0] & d); // next state is S1 when current state is S and d=1
assign Count_next = (state[7] & done_counting); // next state is Count when current state is Count and done_counting=1
assign Wait_next = (state[7] & ~done_counting) | (state[9] & ~ack); // next state is Wait when current state is Count and done_counting=0, or Wait and ack=0

// Output logic
assign shift_ena = state[4] | state[5] | state[6] | state[7]; // shift_ena is 1 when current state is B0, B1, B2, or B3
assign counting = state[7]; // counting is 1 when current state is Count
assign done = state[9]; // done is 1 when current state is Wait

endmodule