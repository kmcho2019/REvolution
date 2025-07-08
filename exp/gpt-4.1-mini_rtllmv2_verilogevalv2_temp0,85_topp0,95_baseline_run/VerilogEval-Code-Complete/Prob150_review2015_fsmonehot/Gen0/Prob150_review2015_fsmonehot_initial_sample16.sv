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

  // State encoding positions for readability:
  // state[0] = S
  // state[1] = S1
  // state[2] = S11
  // state[3] = S110
  // state[4] = B0
  // state[5] = B1
  // state[6] = B2
  // state[7] = B3
  // state[8] = Count
  // state[9] = Wait

  // Next-state logic (one-hot)
  // B3_next:
  // From B2 always go to B3
  assign B3_next = state[6]; 

  // S_next:
  // From S with d=0 -> S
  // From S1 with d=0 -> S
  // From S11 with d=0 -> S110, so no S_next there
  // From S110 with d=0 -> S
  // From Wait with ack=1 -> S
  assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);

  // S1_next:
  // From S with d=1 -> S1
  assign S1_next = state[0] & d;

  // Count_next:
  // From B3 always go to Count
  // From Count when done_counting=0 remain in Count
  assign Count_next = state[7] | (state[8] & ~done_counting);

  // Wait_next:
  // From Count when done_counting=1 -> Wait
  // From Wait when ack=0 remain in Wait
  assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

  // Outputs (Moore machine, outputs depend only on current state)

  // done = 1 in Wait state
  assign done = state[9];

  // counting = 1 in Count state
  assign counting = state[8];

  // shift_ena = 1 in B0, B1, B2, B3 states
  assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule