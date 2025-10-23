module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,   // one-hot encoded current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // State bit indices
  localparam S_POS    = 0;
  localparam S1_POS   = 1;
  localparam S11_POS  = 2;
  localparam S110_POS = 3;
  localparam B0_POS   = 4;
  localparam B1_POS   = 5;
  localparam B2_POS   = 6;
  localparam B3_POS   = 7;
  localparam COUNT_POS= 8;
  localparam WAIT_POS = 9;

  // Decode current states
  wire S     = state[S_POS];
  wire S1    = state[S1_POS];
  wire S11   = state[S11_POS];
  wire S110  = state[S110_POS];
  wire B0    = state[B0_POS];
  wire B1    = state[B1_POS];
  wire B2    = state[B2_POS];
  wire B3    = state[B3_POS];
  wire Count = state[COUNT_POS];
  wire Wait  = state[WAIT_POS];

  // Derive requested next states by inspecting transitions:

  // Next S:
  // S_next if S & ~d (S->S), or S1 & ~d (S1->S), or S110 & ~d (S110->S), or Wait & ack (Wait->S)
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next S1:
  // S1_next if S & d (S->S1)
  assign S1_next = S & d;

  // Next B3:
  // B3_next if B2 (B2->B3)
  assign B3_next = B2;

  // Next Count:
  // Count_next if B3 (B3->Count) or Count & ~done_counting (Count->Count)
  assign Count_next = B3 | (Count & ~done_counting);

  // Next Wait:
  // Wait_next if Count & done_counting (Count->Wait) or Wait & ~ack (Wait->Wait)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs based on current state
  assign shift_ena = B0 | B1 | B2 | B3; // shift_ena=1 for these states
  assign counting  = Count;              // counting=1 for Count state
  assign done      = Wait;               // done=1 for Wait state

endmodule