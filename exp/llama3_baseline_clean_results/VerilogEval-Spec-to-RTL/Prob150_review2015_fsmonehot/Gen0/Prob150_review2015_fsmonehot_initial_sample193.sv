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

wire [9:0] next_state;

// State transition logic
assign next_state[0] = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d);
assign next_state[1] = (state[0] & d);
assign next_state[2] = (state[1] & d);
assign next_state[3] = (state[2] & ~d);
assign next_state[4] = (state[3] & d);
assign next_state[5] = (state[4]);
assign next_state[6] = (state[5]);
assign next_state[7] = (state[6]);
assign next_state[8] = (state[7]) | (state[4] & done_counting);
assign next_state[9] = (state[8] & ~ack);

// Output logic
assign shift_ena = state[4] | state[5] | state[6] | state[7];
assign counting = state[8];
assign done = state[9];

// Next state signals
assign B3_next = next_state[7];
assign S_next = next_state[0];
assign S1_next = next_state[1];
assign Count_next = next_state[8];
assign Wait_next = next_state[9];

endmodule