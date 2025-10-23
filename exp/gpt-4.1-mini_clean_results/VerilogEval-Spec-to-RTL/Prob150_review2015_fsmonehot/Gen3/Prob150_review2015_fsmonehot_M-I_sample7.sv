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

  // Next state signals (only those needed for output or next state detection)
  // Intermediate next_state signals for clarity
  wire next_S;
  wire next_S1;
  wire next_B3;
  wire next_Count;
  wire next_Wait;

  // Next state logic derived by inspection and simplification:

  // S_next: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  assign next_S = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next: from S(d=1)
  assign next_S1 = S & d;

  // B3_next: from B2 (always)
  assign next_B3 = B2;

  // Count_next: from B3 and (Count & ~done_counting)
  assign next_Count = B3 | (Count & ~done_counting);

  // Wait_next: from (Count & done_counting) or (Wait & ~ack)
  assign next_Wait = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore machine) depend on current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

  // Export next-state signals
  assign S_next     = next_S;
  assign S1_next    = next_S1;
  assign B3_next    = next_B3;
  assign Count_next = next_Count;
  assign Wait_next  = next_Wait;

endmodule