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

  // State bits for readability
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

  // Next state logic

  // S_next:
  // from S when d=0
  // from S1 when d=0
  // from S110 when d=0
  // from Wait when ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next:
  // from S when d=1
  assign S1_next = (S & d);

  // Count_next:
  // from B3 (always)
  // from Count when done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // from Count when done_counting=1
  // from Wait when ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // B3_next:
  // from B2 (always)
  assign B3_next = B2;

  // Output logic (Moore)

  // done = 1 in Wait state
  assign done = Wait;

  // counting = 1 in Count state
  assign counting = Count;

  // shift_ena = 1 in B0, B1, B2, B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule