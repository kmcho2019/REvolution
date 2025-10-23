module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded: S[0], S1[1], S11[2], S110[3], B0[4], B1[5], B2[6], B3[7], Count[8], Wait[9]
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Current state one-hot decode
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

  // Next state vector - only bits needed for outputs plus intermediates used in logic
  // We derive only the next states requested as output signals:
  // S_next, S1_next, B3_next, Count_next, Wait_next

  // Next S state transitions:
  // S: S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  // S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
  wire S_n = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next from S(d=1)
  wire S1_n = S & d;

  // B3_next from B2 (always next cycle)
  wire B3_n = B2;

  // Count_next from B3 and Count (if !done_counting)
  wire Count_n = B3 | (Count & ~done_counting);

  // Wait_next from Count(done_counting=1) or Wait(ack=0)
  wire Wait_n = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore outputs depend on current state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

  // Assign outputs for next-state indications
  assign S_next     = S_n;
  assign S1_next    = S1_n;
  assign B3_next    = B3_n;
  assign Count_next = Count_n;
  assign Wait_next  = Wait_n;

endmodule