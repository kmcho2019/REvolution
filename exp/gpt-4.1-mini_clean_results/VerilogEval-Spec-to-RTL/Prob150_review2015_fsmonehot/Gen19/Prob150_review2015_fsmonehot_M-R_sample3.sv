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

  // Define state bit positions as parameters for clarity
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

  // Current state decoding
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

  // Next-state wires for each state in FSM
  wire S_next_w, S1_next_w, S11_next_w, S110_next_w;
  wire B0_next_w, B1_next_w, B2_next_w, B3_next_w, Count_next_w, Wait_next_w;

  // Next-state logic derived by inspection of transition table
  // S state transitions
  assign S_next_w = (S    & ~d) |  // S --d=0--> S
                    (S1   & ~d) |  // S1 --d=0--> S
                    (S110  & ~d) | // S110 --d=0--> S
                    (Wait & ack);  // Wait --ack=1--> S

  assign S1_next_w = S & d;         // S --d=1--> S1

  assign S11_next_w = S1 & d;       // S1 --d=1--> S11

  assign S110_next_w = S11 & ~d;    // S11 --d=0--> S110

  assign B0_next_w = S110 & d;      // S110 --d=1--> B0

  assign B1_next_w = B0;             // B0 --always--> B1

  assign B2_next_w = B1;             // B1 --always--> B2

  assign B3_next_w = B2;             // B2 --always--> B3

  assign Count_next_w = B3 | (Count & ~done_counting); // B3 --always--> Count; Count --done_counting=0--> Count

  assign Wait_next_w = (Count & done_counting) | (Wait & ~ack); // Count --done_counting=1--> Wait; Wait --ack=0--> Wait

  // Outputs (Moore): depend only on current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting = Count;
  assign done = Wait;

  // Output next-state indicators
  assign S_next = S_next_w;
  assign S1_next = S1_next_w;
  assign B3_next = B3_next_w;
  assign Count_next = Count_next_w;
  assign Wait_next = Wait_next_w;

endmodule