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

// next-state logic
assign B3_next = (state[2] & ~d) | (state[3] & ~d);  // B2 -> B3, S110 -> B0 (not B3, but in next cycle B0 -> B1 -> B2 -> B3)
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[9] & ack);  // S -> S, S1 -> S, Wait -> S
assign S1_next = (state[0] & d);  // S -> S1
assign Count_next = (state[4] & done_counting);  // B3 -> Count
assign Wait_next = (state[4] & ~done_counting) | (state[8] & ~ack);  // Count -> Wait, Wait -> Wait

// output logic
assign done = state[8];  // Wait state
assign counting = state[4];  // Count state
assign shift_ena = state[5] | state[6] | state[7] | state[3];  // B0, B1, B2, B3 states

endmodule