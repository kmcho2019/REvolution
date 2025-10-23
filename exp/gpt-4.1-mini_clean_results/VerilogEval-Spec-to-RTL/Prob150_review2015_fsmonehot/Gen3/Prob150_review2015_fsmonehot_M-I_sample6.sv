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

  // Next state logic by inspection of FSM transitions

  // Next state = S if:
  // - S with d=0 stays in S
  // - S1 with d=0 goes to S
  // - S110 with d=0 goes to S
  // - Wait with ack=1 goes to S (reset)
  assign S_next =
    (S    & ~d) |
    (S1   & ~d) |
    (S110 & ~d) |
    (Wait &  ack);

  // Next state = S1 if:
  // - S with d=1 goes to S1
  assign S1_next = S & d;

  // Next state = B3 if:
  // - B2 always goes to B3
  assign B3_next = B2;

  // Next state = Count if:
  // - B3 always goes to Count
  // - Count stays in Count if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state = Wait if:
  // - Count goes to Wait if done_counting=1
  // - Wait stays in Wait if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore machine): depend only on current state

  // shift_ena is asserted in B0,B1,B2,B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting asserted in Count state
  assign counting = Count;

  // done asserted in Wait state
  assign done = Wait;

endmodule