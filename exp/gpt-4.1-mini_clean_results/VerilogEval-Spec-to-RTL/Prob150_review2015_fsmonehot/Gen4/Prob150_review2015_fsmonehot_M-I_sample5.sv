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

  // Current state one-hot bits for readability
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

  // Input complements for clarity
  wire d0 = ~d;
  wire done_cnt1 = done_counting;
  wire ack1 = ack;

  // Next state logic by inspection, factored to reduce fan-in:

  // S_next:
  // From S,d=0 or S1,d=0 or S110,d=0 or Wait,ack=1
  // factor common d0 among first three:
  wire s_states_d0 = (S | S1 | S110) & d0;
  assign S_next = s_states_d0 | (Wait & ack1);

  // S1_next:
  // From S,d=1 only
  assign S1_next = S & d;

  // B3_next:
  // From B2 always
  assign B3_next = B2;

  // Count_next:
  // From B3 always, or Count and not done_counting
  assign Count_next = B3 | (Count & ~done_cnt1);

  // Wait_next:
  // From Count done_counting=1, or Wait ack=0
  assign Wait_next = (Count & done_cnt1) | (Wait & ~ack1);

  // Outputs (Moore machine)

  // shift_ena: asserted in B0,B1,B2,B3
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting: asserted in Count
  assign counting = Count;

  // done: asserted in Wait
  assign done = Wait;

endmodule