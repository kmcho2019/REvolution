module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  // For convenience assign current state bits to named wires
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

  // Next state logic:
  // S_next (state[0] next):
  // from S with d=0
  // from S1 with d=0
  // from S110 with d=0
  // from Wait with ack=1
  assign S_next =
    (S   & ~d) |
    (S1  & ~d) |
    (S110& ~d) |
    (Wait & ack);

  // S1_next (state[1] next):
  // from S with d=1
  assign S1_next = (S & d);

  // B3_next (state[7] next):
  // from B2 always
  assign B3_next = B2;

  // Count_next (state[8] next):
  // from B3 always
  assign Count_next = B3;

  // Wait_next (state[9] next):
  // from Count with done_counting=1
  assign Wait_next = (Count & done_counting);

  // Outputs (Moore outputs depend only on current state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule