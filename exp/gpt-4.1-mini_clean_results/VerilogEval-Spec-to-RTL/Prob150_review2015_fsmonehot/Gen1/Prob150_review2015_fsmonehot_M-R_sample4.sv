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

  // Decode current one-hot state bits for readability
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

  // Next state logic derived by inspection:

  // S_next:
  // from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  wire next_S_from_S       = S    & ~d;
  wire next_S_from_S1      = S1   & ~d;
  wire next_S_from_S110    = S110 & ~d;
  wire next_S_from_Wait    = Wait & ack;
  assign S_next = next_S_from_S | next_S_from_S1 | next_S_from_S110 | next_S_from_Wait;

  // S1_next: from S(d=1)
  assign S1_next = S & d;

  // S11_next (not output): from S1(d=1), S11(d=1)
  wire S11_next = (S1 & d) | (S11 & d);

  // S110_next (not output): from S11(d=0)
  wire S110_next = S11 & ~d;

  // B0_next (not output): from S110(d=1)
  wire B0_next = S110 & d;

  // B1_next (not output): from B0
  wire B1_next = B0;

  // B2_next (not output): from B1
  wire B2_next = B1;

  // B3_next: from B2
  assign B3_next = B2;

  // Count_next:
  // from B3 or remain in Count if done_counting=0
  // So Count_next = B3 or (Count and ~done_counting)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // from Count(done_counting=1) or Wait(ack=0)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore machine):
  assign done = Wait;
  assign counting = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule