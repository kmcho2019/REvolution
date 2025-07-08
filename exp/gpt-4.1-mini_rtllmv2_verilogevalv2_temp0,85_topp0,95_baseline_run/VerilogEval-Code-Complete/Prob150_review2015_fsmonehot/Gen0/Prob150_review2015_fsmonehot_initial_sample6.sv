module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

// Current states for clarity
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

// Next-state logic:

// S_next:
// S_next = (S & ~d) | (S1 & ~d) | (S11 & ~d) | (S110 & ~d) | (Wait & ack)
assign S_next = (S & ~d) | (S1 & ~d) | (S11 & ~d) | (S110 & ~d) | (Wait & ack);

// S1_next:
// S1_next = S & d
assign S1_next = S & d;

// B3_next:
// B3_next = B2 (always next)
assign B3_next = B2;

// Count_next:
// Count_next = B3 (always next)
assign Count_next = B3;

// Wait_next:
// Wait_next = Count & done_counting
assign Wait_next = Count & done_counting;

// Output logic:

// done = 1 when state=Wait
assign done = Wait;

// counting = 1 when state=Count
assign counting = Count;

// shift_ena = 1 when state in {B0,B1,B2,B3}
assign shift_ena = B0 | B1 | B2 | B3;

endmodule