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
reg B3_next, S_next, S1_next, Count_next, Wait_next;

// Current state bits
wire S     = state[0];
wire S1    = state[1];
wire S11   = state[2];
wire S110  = state[3];
wire B0    = state[4];
wire B1    = state[5];
wire B2    = state[6];
wire B3    = state[7];
wire Count = state[8];
wire Wait  = state[9];

// Next-state logic
assign B3_next = (S110 & d) | (B2); // Go to B3 when in S110 and d=1, or when in B2
assign S_next  = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack); // Go to S when in S and d=0, or in S1 and d=0, or in S110 and d=0, or in Wait and ack=1
assign S1_next = (S & d); // Go to S1 when in S and d=1
assign Count_next = (B3); // Go to Count when in B3
assign Wait_next = (Count & done_counting); // Go to Wait when in Count and done_counting=1

// Output logic
assign shift_ena = (B0 | B1 | B2 | B3); // Shift enable is high when in B0, B1, B2, or B3
assign counting = (Count); // Counting is high when in Count
assign done = (Wait); // Done is high when in Wait

endmodule