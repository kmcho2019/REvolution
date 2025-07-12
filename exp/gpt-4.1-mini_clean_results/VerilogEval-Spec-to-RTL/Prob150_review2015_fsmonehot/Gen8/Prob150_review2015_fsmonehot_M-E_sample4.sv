module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,   // one-hot encoding current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current state bits
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

  // Next-state logic (one-hot signals) assigned explicitly:

  // Next S state: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  assign S_next = (S    & ~d)      // S->S on d=0
                | (S1   & ~d)      // S1->S on d=0
                | (S110  & ~d)     // S110->S on d=0
                | (Wait  & ack);   // Wait->S on ack=1

  // Next S1 state: from S(d=1)
  assign S1_next = S & d;

  // Next S11 state: from S1(d=1), stays if d=1
  wire S11_next = (S1 & d) | (S11 & d);

  // Next S110 state: from S11(d=0)
  wire S110_next = S11 & ~d;

  // Next B0 state: from S110(d=1)
  wire B0_next = S110 & d;

  // Next B1 state: from B0
  wire B1_next = B0;

  // Next B2 state: from B1
  wire B2_next = B1;

  // Next B3 state: from B2
  assign B3_next = B2;

  // Next Count state: from B3, or stay in Count if done_counting=0
  assign Count_next = (B3) | (Count & ~done_counting);

  // Next Wait state: from Count(done_counting=1), or stay in Wait if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore) depend only on current state:
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule