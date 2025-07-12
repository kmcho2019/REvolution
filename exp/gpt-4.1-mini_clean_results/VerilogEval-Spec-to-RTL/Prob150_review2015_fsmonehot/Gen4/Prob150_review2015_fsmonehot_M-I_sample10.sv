module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // One-hot current state bits
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

  // Next-state logic:

  // Next state = S if:
  // - from S with d=0
  // - from S1 with d=0
  // - from S110 with d=0
  // - from Wait with ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next state = S1 only from S with d=1
  assign S1_next = S & d;

  // Next state = B3 only from B2 (always move forward)
  assign B3_next = B2;

  // Next state = Count from B3 or Count (if !done_counting)
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state = Wait from Count(done_counting=1) or Wait(ack=0)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore output signals
  assign shift_ena = B0 | B1 | B2 | B3;
  assign done = Wait;
  assign counting = Count;

endmodule