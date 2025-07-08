module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  // State bit encoding for clarity
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

  // Next state logic by inspection (one-hot encoding)

  // S_next: next state is S
  // Transitions to S:
  // - from S when d=0
  // - from S1 when d=0
  // - from S110 when d=0
  // - from Wait when ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next: next state is S1
  // - from S when d=1
  assign S1_next = S & d;

  // B3_next: next state is B3
  // - from B2, always next
  assign B3_next = B2;

  // Count_next: next state is Count
  // - from B3, always next
  assign Count_next = B3;

  // Wait_next: next state is Wait
  // - from Count when done_counting=1
  assign Wait_next = Count & done_counting;

  // Outputs depend on current state
  assign done = Wait;
  assign counting = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule