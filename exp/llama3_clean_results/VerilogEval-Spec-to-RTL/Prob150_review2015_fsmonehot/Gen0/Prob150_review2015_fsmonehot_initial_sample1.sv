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

// Next-state logic
assign B3_next = state[6];  // B2 state (6th bit is set for B2)
assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);  // S, S1, S110 states or Wait state with ack=1
assign S1_next = state[0] & d;  // S state with d=1
assign Count_next = state[7];  // B3 state
assign Wait_next = state[7] & done_counting;  // Count state with done_counting=1

// Output logic
assign done = state[9];  // Wait state
assign counting = state[7];  // Count state
assign shift_ena = state[4] | state[5] | state[6] | state[7];  // B0, B1, B2, or B3 states

endmodule