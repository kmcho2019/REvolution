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

  // State encoding positions
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

  // Decode current state bits
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

  // Transition conditions
  // From S
  wire S_to_S   = S & (~d);
  wire S_to_S1  = S & d;

  // From S1
  wire S1_to_S  = S1 & (~d);
  wire S1_to_S11 = S1 & d;

  // From S11
  wire S11_to_S110 = S11 & (~d);
  wire S11_to_S11  = S11 & d;

  // From S110
  wire S110_to_S = S110 & (~d);
  wire S110_to_B0 = S110 & d;

  // From B0
  wire B0_to_B1 = B0;

  // From B1
  wire B1_to_B2 = B1;

  // From B2
  wire B2_to_B3 = B2;

  // From B3
  wire B3_to_Count = B3;

  // From Count
  wire Count_to_Count = Count & (~done_counting);
  wire Count_to_Wait = Count & done_counting;

  // From Wait
  wire Wait_to_Wait = Wait & (~ack);
  wire Wait_to_S    = Wait & ack;

  // Next-state signals as OR of transition conditions targeting that state
  assign S_next     = S_to_S | S1_to_S | S110_to_S | Wait_to_S;
  assign S1_next    = S_to_S1;
  assign S11_next   = S1_to_S11;
  assign S110_next  = S11_to_S110;
  assign B0_next    = S110_to_B0;
  assign B1_next    = B0_to_B1;
  assign B2_next    = B1_to_B2;
  assign B3_next    = B2_to_B3;
  assign Count_next = B3_to_Count | Count_to_Count;
  assign Wait_next  = Count_to_Wait | Wait_to_Wait;

  // Output logic (Moore outputs depend only on current state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule