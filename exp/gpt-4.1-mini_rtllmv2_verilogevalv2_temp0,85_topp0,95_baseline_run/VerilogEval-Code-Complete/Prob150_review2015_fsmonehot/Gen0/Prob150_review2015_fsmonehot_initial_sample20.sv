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

  // State encoding (one-hot)
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

  // Next state signals logic by inspection:

  // S_next: Next state is S when:
  // From S: d=0 --> S
  // From S1: d=0 --> S
  // From S110: d=0 --> S
  // From Wait: ack=1 --> S
  assign S_next = 
       (state[0]  & ~d)           // S + d=0
    |  (state[1]  & ~d)           // S1 + d=0
    |  (state[3]  & ~d)           // S110 + d=0
    |  (state[9]  & ack);         // Wait + ack=1

  // S1_next: Next state is S1 when:
  // From S: d=1 --> S1
  assign S1_next = (state[0] & d);

  // B3_next: Next state is B3 when:
  // From B2: always next cycle -> B3
  assign B3_next = state[6];

  // Count_next: Next state is Count when:
  // From B3: always next cycle -> Count
  assign Count_next = state[7];

  // Wait_next: Next state is Wait when:
  // From Count: done_counting=1 --> Wait
  assign Wait_next = (state[8] & done_counting);

  // Outputs are Moore style: only depend on current state

  // done = 1 in Wait
  assign done = state[9];

  // counting = 1 in Count
  assign counting = state[8];

  // shift_ena = 1 in B0, B1, B2, B3
  assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule