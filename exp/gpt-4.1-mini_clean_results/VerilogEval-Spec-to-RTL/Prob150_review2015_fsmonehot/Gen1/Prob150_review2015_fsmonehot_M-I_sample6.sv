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

  // S_next: next state is S if:
  // S with d=0 -> S
  // S1 with d=0 -> S
  // S110 with d=0 -> S
  // Wait with ack=1 -> S
  assign S_next =
    (S    & ~d) |
    (S1   & ~d) |
    (S110 & ~d) |
    (Wait & ack);

  // S1_next: next state is S1 if
  // S with d=1 -> S1
  assign S1_next = S & d;

  // B3_next: next state is B3 if
  // B2 -> B3 (always)
  assign B3_next = B2;

  // Count_next: next state is Count if
  // B3 -> Count (always)
  // or Count & done_counting=0 (self-loop)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next: next state is Wait if
  // Count & done_counting=1 -> Wait
  // Wait & ack=0 -> Wait (self-loop)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs depend on current state (Moore machine)

  // shift_ena = 1 in B0,B1,B2,B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting = 1 in Count state
  assign counting = Count;

  // done = 1 in Wait state
  assign done = Wait;

endmodule