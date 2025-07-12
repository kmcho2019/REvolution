module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoded state
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
    assign B3_next = (state[6] & 1'b1);  // B3_next is asserted when next-state is B3
    assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);  // S_next is asserted when next-state is S
    assign S1_next = state[0] & d;  // S1_next is asserted when next-state is S1
    assign Count_next = state[7];  // Count_next is asserted when next-state is Count
    assign Wait_next = state[8] & done_counting;  // Wait_next is asserted when next-state is Wait

    // output logic
    assign done = state[8];  // done is asserted when current state is Wait
    assign counting = state[7];  // counting is asserted when current state is Count
    assign shift_ena = state[4] | state[5] | state[6] | state[7];  // shift_ena is asserted when current state is B0, B1, B2, or B3

endmodule