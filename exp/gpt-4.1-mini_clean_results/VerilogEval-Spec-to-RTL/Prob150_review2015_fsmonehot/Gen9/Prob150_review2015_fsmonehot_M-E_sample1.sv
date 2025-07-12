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

  // Decode current state bits for convenience
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

  // Next state B3: from B2 unconditionally
  // B3_next = B2
  assign B3_next = B2;

  // Next state S:
  // From S on d=0 -> S
  // From S1 on d=0 -> S
  // From S110 on d=0 -> S
  // From Wait on ack=1 -> S
  assign S_next =
        (S     & ~d) |
        (S1    & ~d) |
        (S110  & ~d) |
        (Wait  & ack);

  // Next state S1:
  // From S on d=1 -> S1
  assign S1_next = S & d;

  // Next state Count:
  // From B3 unconditionally
  // From Count while done_counting=0 remain in Count
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state Wait:
  // From Count when done_counting=1 -> Wait
  // From Wait while ack=0 remain in Wait
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs (depend only on current state)
  // shift_ena = 1 on B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting = 1 in Count state
  assign counting = Count;

  // done = 1 in Wait state
  assign done = Wait;

endmodule