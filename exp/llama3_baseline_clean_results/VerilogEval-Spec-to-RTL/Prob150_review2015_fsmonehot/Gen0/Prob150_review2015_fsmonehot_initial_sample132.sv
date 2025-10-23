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
assign shift_ena = (state[5] | state[4] | state[3] | state[2]);  // B0, B1, B2, B3
assign counting = state[7];  // Count
assign done = state[9];  // Wait

// Next-state logic
assign B3_next = (state[5] | (state[3] & ~d));  // B0, B2 when d=1
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[2] & ~d) | (state[9] & ack);  // S when d=0, S1 when d=0, S110 when d=0, Wait when ack=1
assign S1_next = state[0] & d;  // S when d=1
assign Count_next = (state[8] & done_counting);  // Count when done_counting=1
assign Wait_next = (state[8] & ~done_counting) | (state[9] & ~ack);  // Count when done_counting=0, Wait when ack=0

endmodule