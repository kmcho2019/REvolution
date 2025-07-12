module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoding of current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // One-hot decoded current states for clarity
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

  // Next-state logic for requested next state signals:

  // S_next:
  // From S, S1, S110 when d=0, or from Wait when ack=1
  assign S_next = ( (S | S1 | S110) & ~d ) | (Wait & ack);

  // S1_next:
  // From S when d=1
  assign S1_next = S & d;

  // B3_next:
  // Always from B2 (always next cycle)
  assign B3_next = B2;

  // Count_next:
  // From B3, or remain in Count while done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // From Count when done_counting=1, or remain in Wait while ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore output signals depend only on current state

  // shift_ena asserted in states B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting asserted in Count state
  assign counting = Count;

  // done asserted in Wait state
  assign done = Wait;

endmodule