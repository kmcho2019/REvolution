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

// Output logic
assign shift_ena = (state[5] | state[4] | state[3] | state[2]); // B0, B1, B2, B3
assign counting = state[7]; // Count
assign done = state[9]; // Wait

// Next-state logic
assign B3_next = (state[4] & 1'b1); // B2
assign S_next = ((state[0] & ~d) | (state[1] & ~d) | (state[6] & ~d) | (state[8] & ack)); // S, S1, S110, Wait
assign S1_next = (state[0] & d); // S
assign Count_next = (state[2] | (state[7] & ~done_counting)); // B3, Count
assign Wait_next = (state[7] & done_counting); // Count

endmodule