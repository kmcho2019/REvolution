module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,   // one-hot encoding of current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Current state one-hot bits
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

  // Next state logic by inspection:
  // S transitions
  // S: d=0 -> S; d=1 -> S1
  // S1: d=0 -> S; d=1 -> S11
  // S11: d=0 -> S110; d=1 -> S11
  // S110: d=0 -> S; d=1 -> B0
  // B0->B1->B2->B3->Count sequential next states
  // Count: done_counting=0 -> Count, done_counting=1 -> Wait
  // Wait: ack=0 -> Wait, ack=1 -> S

  // S_next asserted if next state is S:
  // Next state is S if:
  // From S with d=0: S & ~d
  // From S1 with d=0: S1 & ~d
  // From S11 with d=0: S11 & ~d -> Actually S11 d=0 -> S110 not S; correction: S11 with d=0 -> S110, so no
  // From S110 with d=0: S110 & ~d
  // From Wait with ack=1: Wait & ack
  //
  // So S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack)

  assign S_next =
    (S    & ~d) |
    (S1   & ~d) |
    (S110 & ~d) |
    (Wait & ack);

  // S1_next is next state = S1:
  // S with d=1 -> S1
  // No other next states to S1
  assign S1_next = S & d;

  // B3_next is next state = B3:
  // From B2 always next to B3
  assign B3_next = B2;

  // Count_next is next state = Count:
  // From B3 always to Count
  assign Count_next = B3;

  // Wait_next is next state = Wait:
  // From Count done_counting=1 -> Wait
  assign Wait_next = Count & done_counting;

  // shift_ena = 1 in states B0, B1, B2, B3 (current state)
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting = 1 in Count state (current state)
  assign counting = Count;

  // done = 1 in Wait state (current state)
  assign done = Wait;

endmodule