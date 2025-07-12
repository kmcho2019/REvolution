module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// one-hot encoding 
// (S, S1, S11, S110, B0, B1, B2, B3, Count, Wait)
// = (10'b0000000001, 10'b0000000010, 10'b0000000100, ... , 10'b1000000000)

// next-state logic
assign B3_next = state[6]; // B3 next state is asserted when current state is B2
assign S_next = (state[0] && !d) || (state[1] && !d) || (state[2] && !d) || (state[3] && !d) || (state[9] && ack); // S next state is asserted when current state is S, S1, S11, S110 or Wait and ack
assign S1_next = state[0] && d; // S1 next state is asserted when current state is S and d
assign Count_next = state[7]; // Count next state is asserted when current state is B3
assign Wait_next = state[8] || (state[7] && done_counting); // Wait next state is asserted when current state is Count and done_counting

// output logic
assign done = state[9]; // done is asserted when current state is Wait
assign counting = state[7]; // counting is asserted when current state is Count
assign shift_ena = state[4] || state[5] || state[6] || state[7]; // shift_ena is asserted when current state is B0, B1, B2 or B3

endmodule