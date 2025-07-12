module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,      // one-hot encoding: S=0 ... Wait=9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Current state one-hot bits for clarity
  wire S    = state[0];
  wire S1   = state[1];
  wire S11  = state[2];
  wire S110 = state[3];
  wire B0   = state[4];
  wire B1   = state[5];
  wire B2   = state[6];
  wire B3   = state[7];
  wire Count = state[8];
  wire Wait = state[9];

  // Next state bits by enumerating each state transition:

  // S_next: next state is S when:
  // - current S and d=0
  // - current S1 and d=0
  // - current S110 and d=0
  // - current Wait and ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next: next state is S1 when:
  // - current S and d=1
  assign S1_next = S & d;

  // B3_next: next state is B3 when:
  // - current B2 (always transitions to B3)
  assign B3_next = B2;

  // Count_next: next state is Count when:
  // - current B3 (always transitions to Count)
  // - current Count and done_counting=0 (remains in Count)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next: next state is Wait when:
  // - current Count and done_counting=1
  // - current Wait and ack=0 (remains in Wait)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Other next state bits are not requested, so they remain zero.

  // Moore outputs depend only on current state:

  // done asserted in Wait
  assign done = Wait;

  // counting asserted in Count
  assign counting = Count;

  // shift_ena asserted in B0, B1, B2, B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule