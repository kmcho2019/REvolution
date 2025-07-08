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

  // Current states for readability
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

  // Next state logic for each next state signal:

  // S_next:
  // From S with d=0
  // From S1 with d=0
  // From S110 with d=0
  // From Wait with ack=1
  assign S_next =
        (S    & ~d) |
        (S1   & ~d) |
        (S110 & ~d) |
        (Wait & ack);

  // S1_next:
  // From S with d=1
  assign S1_next = S & d;

  // B3_next:
  // From B2 (always next)
  assign B3_next = B2;

  // Count_next:
  // From B3 (always next)
  // From Count & done_counting=0 (stay in Count)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // From Count & done_counting=1
  // From Wait & ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // shift_ena is 1 in B0, B1, B2, B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting is 1 in Count state
  assign counting = Count;

  // done is 1 in Wait state
  assign done = Wait;

endmodule