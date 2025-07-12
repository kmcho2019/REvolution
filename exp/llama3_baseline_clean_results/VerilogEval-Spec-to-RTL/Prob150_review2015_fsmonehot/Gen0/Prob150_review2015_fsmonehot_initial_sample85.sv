module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state, // One-hot encoding
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
assign B3_next = (state[8] == 1'b1); // Next state is B3
assign S_next = (state[0] == 1'b1 && d == 1'b0) ||
                (state[1] == 1'b1 && d == 1'b0) ||
                (state[3] == 1'b1 && d == 1'b0) ||
                (state[9] == 1'b1 && ack == 1'b1); // Next state is S
assign S1_next = (state[0] == 1'b1 && d == 1'b1); // Next state is S1
assign Count_next = (state[7] == 1'b1 && done_counting == 1'b1); // Next state is Count
assign Wait_next = (state[7] == 1'b1 && done_counting == 1'b0) || 
                   (state[9] == 1'b1 && ack == 1'b0); // Next state is Wait

// Output logic
assign done = state[9]; // Output done when in Wait state
assign counting = state[7]; // Output counting when in Count state
assign shift_ena = state[4] || state[5] || state[6] || state[8]; // Output shift_ena when in B0, B1, B2, or B3 states

endmodule