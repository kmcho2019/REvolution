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

// One-hot encoding for each state
wire S = state[0];
wire S1 = state[1];
wire S11 = state[2];
wire S110 = state[3];
wire B0 = state[4];
wire B1 = state[5];
wire B2 = state[6];
wire B3 = state[7];
wire Count = state[8];
wire Wait = state[9];

// Next-state logic equations
assign B3_next = (B2);  // B2 always goes to B3
assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);  // S, S1, and S110 go to S on d=0, and Wait goes to S on ack=1
assign S1_next = (S & d);  // S goes to S1 on d=1
assign Count_next = (B3);  // B3 always goes to Count
assign Wait_next = (Count & done_counting);  // Count goes to Wait on done_counting=1

// Output logic equations
assign shift_ena = B0 | B1 | B2 | B3;  // shift_ena is 1 in states B0, B1, B2, and B3
assign counting = Count;  // counting is 1 in state Count
assign done = Wait;  // done is 1 in state Wait

endmodule