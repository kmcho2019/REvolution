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

  // Decode current states
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

  // Next state logic - combined and simplified
  // S_next is asserted when:
  // - from S on d=0
  // - from S1 on d=0
  // - from S110 on d=0
  // - from Wait on ack=1
  assign S_next = ( (S | S1 | S110) & ~d ) | (Wait & ack);

  // S1_next is asserted only from S on d=1
  assign S1_next = S & d;

  // B3_next from B2 (always)
  assign B3_next = B2;

  // Count_next is asserted:
  // - from B3 (always)
  // - stay in Count if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next is asserted:
  // - from Count if done_counting=1
  // - stay in Wait if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs from current state
  // shift_ena is asserted in B0, B1, B2, B3 states
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule