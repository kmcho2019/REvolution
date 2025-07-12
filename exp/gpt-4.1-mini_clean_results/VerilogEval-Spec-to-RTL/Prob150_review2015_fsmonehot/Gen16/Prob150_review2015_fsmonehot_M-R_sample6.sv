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

  // Current state decoding
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

  // Next state bits (one-hot)
  wire S_next_bit;
  wire S1_next_bit;
  wire S11_next_bit;
  wire S110_next_bit;
  wire B0_next_bit;
  wire B1_next_bit;
  wire B2_next_bit;
  wire B3_next_bit;
  wire Count_next_bit;
  wire Wait_next_bit;

  // Next state logic derived by inspection:

  // From S state:
  //   d=0 -> S
  //   d=1 -> S1
  assign S_next_bit   = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
  assign S1_next_bit  = S & d;

  // From S1 state:
  //   d=0 -> S
  //   d=1 -> S11
  assign S11_next_bit = S1 & d;

  // From S11 state:
  //   d=0 -> S110
  //   d=1 -> S11
  assign S11_next_bit = S11_next_bit | (S11 & d); // OR with previous S11_next_bit

  assign S110_next_bit = S11 & ~d;

  // From S110 state:
  //   d=0 -> S
  //   d=1 -> B0
  assign B0_next_bit   = S110 & d;
  assign S_next_bit    = S_next_bit | (S110 & ~d); // include this condition in S_next_bit

  // From B0 to B3 states:
  //   always go to next cycle: B0->B1, B1->B2, B2->B3, B3->Count
  assign B1_next_bit = B0;
  assign B2_next_bit = B1;
  assign B3_next_bit = B2;
  assign Count_next_bit = B3;

  // From Count state:
  //   done_counting=0 -> Count
  //   done_counting=1 -> Wait
  assign Count_next_bit = Count_next_bit | (Count & ~done_counting);
  assign Wait_next_bit  = (Count & done_counting) | (Wait & ~ack);

  // From Wait state:
  //   ack=0 -> Wait
  //   ack=1 -> S (included above in S_next_bit)

  // Outputs
  assign B3_next   = B3_next_bit;
  assign S_next    = S_next_bit;
  assign S1_next   = S1_next_bit;
  assign Count_next= Count_next_bit;
  assign Wait_next = Wait_next_bit;

  assign done      = Wait;
  assign counting  = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule