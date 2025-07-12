module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded: S=bit0, S1=bit1, S11=bit2, S110=bit3, B0=bit4, B1=bit5, B2=bit6, B3=bit7, Count=bit8, Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // State bits for convenience
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

  // Next-state signals by inspection of transitions:
  // S_next = from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next = from S(d=1)
  assign S1_next = S & d;

  // S11_next = from S1(d=1), S11(d=1)
  wire S11_next = (S1 & d) | (S11 & d);

  // S110_next = from S11(d=0)
  wire S110_next = S11 & ~d;

  // B0_next = from S110(d=1)
  wire B0_next = S110 & d;

  // B1_next = from B0 (always next cycle)
  wire B1_next = B0;

  // B2_next = from B1 (always next cycle)
  wire B2_next = B1;

  // B3_next = from B2 (always next cycle)
  assign B3_next = B2;

  // Count_next = from B3 (always next cycle)
  assign Count_next = B3;

  // Count remains in Count until done_counting=1 then goes to Wait
  assign Count_next = Count_next | (Count & ~done_counting);

  // Wait_next = from Count(done_counting=1) or Wait(ack=0)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs: Moore machine - depend only on current state
  // done=1 only in Wait state
  assign done = Wait;

  // counting=1 only in Count state
  assign counting = Count;

  // shift_ena=1 in states B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

  // We only output the next state signals specified
  // Note S11_next, B0_next, B1_next, B2_next not requested to output

endmodule