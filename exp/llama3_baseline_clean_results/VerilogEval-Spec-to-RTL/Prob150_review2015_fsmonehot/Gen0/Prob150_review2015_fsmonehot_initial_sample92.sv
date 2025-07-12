module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state, // One-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// One-hot encoding assumption
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

// Output logic
assign shift_ena = (B0 | B1 | B2 | B3); // Assert in B0, B1, B2, B3 states
assign counting  = Count;              // Assert in Count state
assign done      = Wait;              // Assert in Wait state

// Next-state logic
assign B3_next  = (B2);               // Always go to B3 from B2
assign S_next   = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack); // Conditions to go to S state
assign S1_next  = (S & d);            // Go to S1 from S when d=1
assign Count_next = (B3);             // Always go to Count from B3
assign Wait_next = (Count & done_counting); // Go to Wait from Count when done_counting=1

endmodule