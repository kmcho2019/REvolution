module TopModule (
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

// Next state logic (only outputs we need to generate)
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
assign S1_next = state[0] & d;
assign B3_next = state[6];  // B2 (index 6) transitions to B3 (index 7)
assign Count_next = state[7];  // B3 (index 7) transitions to Count (index 8)
assign Wait_next = state[8] & done_counting;  // Count (index 8) transitions to Wait (index 9)

// Output logic
assign done = state[9];  // Wait state
assign counting = state[8];  // Count state
assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0-B3 states

endmodule