module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current states
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

  // Common conditions
  wire d0 = ~d;
  wire d1 = d;

  // Next-state signals explicitly defined
  wire S_next_w   = (S & d0) | (S1 & d0) | (S110 & d0) | (Wait & ack);
  wire S1_next_w  = S & d1;
  wire S11_next_w = S1 & d1 | S11 & d1;    // For completeness, not an output
  wire S110_next_w= S11 & d0;
  wire B0_next_w  = S110 & d1;
  wire B1_next_w  = B0;
  wire B2_next_w  = B1;
  wire B3_next_w  = B2;
  wire Count_next_w = B3 | (Count & ~done_counting);
  wire Wait_next_w  = (Count & done_counting) | (Wait & ~ack);

  // Assign outputs for requested next states
  assign S_next    = S_next_w;
  assign S1_next   = S1_next_w;
  assign B3_next   = B3_next_w;
  assign Count_next= Count_next_w;
  assign Wait_next = Wait_next_w;

  // Outputs from current state (Moore machine)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule