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

  // Next state logic simplified and decomposed to individual signals

  // Next S: from S (d=0), S1(d=0), S110(d=0), Wait(ack=1)
  wire S_next_int = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next S1: from S (d=1)
  wire S1_next_int = S & d;

  // Next S11: from S1(d=1) or S11 (always)
  wire S11_next = S1 & d | S11; // S11 is stable if d=1 or 0 (always), from diagram it's (S1 & d) -> S11 and (S11 & d) -> S11, also S11 & ~d -> S110 (so careful)
  // The diagram says:
  // S11(d=0) -> S110
  // S11(d=1) -> S11
  // So actually S11_next = (S11 & d) | (S1 & d) 
  // For d=0, next state is S110, handled below

  // Next S110: from S11(d=0)
  wire S110_next = S11 & ~d;

  // Next B0: from S110(d=1)
  wire B0_next = S110 & d;

  // Next B1: from B0 (always)
  wire B1_next = B0;

  // Next B2: from B1 (always)
  wire B2_next = B1;

  // Next B3: from B2 (always)
  wire B3_next_int = B2;

  // Next Count: from B3 (always), or Count(done_counting=0)
  wire Count_next_int = B3 | (Count & ~done_counting);

  // Next Wait: from Count(done_counting=1), or Wait(ack=0)
  wire Wait_next_int = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore, depend on current state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

  // Export next state outputs as requested
  assign S_next     = S_next_int;
  assign S1_next    = S1_next_int;
  assign B3_next    = B3_next_int;
  assign Count_next = Count_next_int;
  assign Wait_next  = Wait_next_int;

endmodule