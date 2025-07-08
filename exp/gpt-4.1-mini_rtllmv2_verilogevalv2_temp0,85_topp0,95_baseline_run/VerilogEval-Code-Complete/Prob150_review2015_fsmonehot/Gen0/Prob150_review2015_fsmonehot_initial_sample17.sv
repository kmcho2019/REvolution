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

  // State bits according to one-hot encoding:
  // S     = state[0]
  // S1    = state[1]
  // S11   = state[2]
  // S110  = state[3]
  // B0    = state[4]
  // B1    = state[5]
  // B2    = state[6]
  // B3    = state[7]
  // Count = state[8]
  // Wait  = state[9]

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

  // Next state logic by inspection:

  // S_next:
  // From S: d=0 -> S
  // From S1: d=0 -> S
  // From S110: d=0 -> S
  // From Wait: ack=1 -> S
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next:
  // From S: d=1 -> S1
  assign S1_next = (S & d);

  // B3_next:
  // From B2: always -> B3
  assign B3_next = B2;

  // Count_next:
  // From B3: always -> Count
  assign Count_next = B3;

  // Wait_next:
  // From Count: done_counting=1 -> Wait
  assign Wait_next = Count & done_counting;

  // Outputs (Moore outputs by state):

  // done = 1 in Wait state
  assign done = Wait;

  // counting = 1 in Count state
  assign counting = Count;

  // shift_ena = 1 in B0, B1, B2, B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule