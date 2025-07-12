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

  // Next state vector (10 bits), each bit corresponds to one-hot next state
  wire [9:0] next_state;

  assign next_state[0] = (S    & ~d) | (S1   & ~d) | (S110 & ~d) | (Wait & ack);      // S
  assign next_state[1] = S & d;                                                      // S1
  assign next_state[2] = (S1  & d) | (S11  & d) | (S11  & ~d);  // S11 transitions (not required for output)
  assign next_state[3] = (S11 & ~d);                                                // S110 (not required for output)
  assign next_state[4] = (S110 & d);                                                // B0 (not required for output)
  assign next_state[5] = B0;                                                        // B1 (not required for output)
  assign next_state[6] = B1;                                                        // B2 (not required for output)
  assign next_state[7] = B2;                                                        // B3
  assign next_state[8] = B3 | (Count & ~done_counting);                             // Count
  assign next_state[9] = (Count & done_counting) | (Wait & ~ack);                   // Wait

  // Outputs (Moore machine) depend on current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

  // Export next-state signals
  assign S_next     = next_state[0];
  assign S1_next    = next_state[1];
  assign B3_next    = next_state[7];
  assign Count_next = next_state[8];
  assign Wait_next  = next_state[9];

endmodule