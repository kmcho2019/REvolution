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

  // State encoding bits:
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

  // Next state logic for S_next:
  // S is next when:
  // - From S, if d=0
  // - From S1, if d=0
  // - From S11, if d=0
  // - From S110, if d=0
  // - From Wait, if ack=1
  assign S_next = 
       (state[0]  & ~d)       // S & d=0 -> S
    |  (state[1]  & ~d)       // S1 & d=0 -> S
    |  (state[2]  & ~d)       // S11 & d=0 -> S110 but S_next is only S, so no. Actually from S11 & d=0 -> S110, no S. So remove this term.
    |  (state[3]  & ~d)       // S110 & d=0 -> S
    |  (state[9]  & ack);     // Wait & ack=1 -> S

  // Correction: The original had S11 & d=0 -> S110, so no S_next from S11 & d=0
  // So remove (state[2]&~d) from S_next.

  assign S_next = 
       (state[0]  & ~d)       // S & d=0 -> S
    |  (state[1]  & ~d)       // S1 & d=0 -> S
    |  (state[3]  & ~d)       // S110 & d=0 -> S
    |  (state[9]  & ack);     // Wait & ack=1 -> S

  // S1_next is next when:
  // - From S, d=1 -> S1
  assign S1_next = state[0] & d;

  // B3_next:
  // - From B2 always -> B3
  assign B3_next = state[6];

  // Count_next:
  // - From B3 always -> Count
  // - Stay in Count if done_counting=0
  assign Count_next = (state[7]) | (state[8] & ~done_counting);

  // Wait_next:
  // - From Count when done_counting=1 -> Wait
  // - Stay in Wait if ack=0
  assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

  // Output logic:
  // done = Wait state
  assign done = state[9];

  // counting = Count state
  assign counting = state[8];

  // shift_ena = B0,B1,B2,B3 states
  assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule