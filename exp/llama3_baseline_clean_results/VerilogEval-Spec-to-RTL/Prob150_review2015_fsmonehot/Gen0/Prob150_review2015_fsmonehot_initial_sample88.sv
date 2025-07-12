module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State bits
wire S    = state[0];
wire S1   = state[1];
wire S11  = state[2];
wire S110 = state[3];
wire B0   = state[4];
wire B1   = state[5];
wire B2   = state[6];
wire B3   = state[7];
wire Count= state[8];
wire Wait = state[9];

// Next-state logic
assign B3_next = (S110 & d) | (B2); // Transition to B3 from S110 with d=1 or from B2
assign S_next  = (S & !d) | (S1 & !d) | (S110 & !d) | (Wait & ack); // Transition to S
assign S1_next = (S & d); // Transition to S1 from S with d=1
assign Count_next = (B3) | (Count & !done_counting); // Transition to Count from B3 or stay in Count if not done_counting
assign Wait_next = (Count & done_counting) | (Wait & !ack); // Transition to Wait from Count with done_counting=1 or stay in Wait if !ack

// Output logic
assign shift_ena = B0 | B1 | B2 | B3; // Assert shift_ena in B0, B1, B2, B3 states
assign counting = Count; // Assert counting in Count state
assign done = Wait; // Assert done in Wait state

endmodule