module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // One-hot state indices
  localparam S_bit     = 0;
  localparam S1_bit    = 1;
  localparam S11_bit   = 2;
  localparam S110_bit  = 3;
  localparam B0_bit    = 4;
  localparam B1_bit    = 5;
  localparam B2_bit    = 6;
  localparam B3_bit    = 7;
  localparam Count_bit = 8;
  localparam Wait_bit  = 9;

  // Current state bits
  wire S     = state[S_bit];
  wire S1    = state[S1_bit];
  wire S11   = state[S11_bit];
  wire S110  = state[S110_bit];
  wire B0    = state[B0_bit];
  wire B1    = state[B1_bit];
  wire B2    = state[B2_bit];
  wire B3    = state[B3_bit];
  wire Count = state[Count_bit];
  wire Wait  = state[Wait_bit];

  // Next state logic by explicit sum-of-products from FSM transitions:

  // S_next: from S when d=0, from S1 when d=0, from S110 when d=0, from Wait when ack=1
  assign S_next = (S    & ~d)   | 
                  (S1   & ~d)   |
                  (S110 & ~d)   |
                  (Wait & ack);

  // S1_next: from S when d=1
  assign S1_next = S & d;

  // S11_next: from S1 when d=1
  // Note: Although not asked to output S11_next, we do not assign it

  // S110_next: from S11 when d=0
  // Similarly, no output needed

  // B0_next: from S110 when d=1
  // Not required as output

  // B1_next: from B0 (always next cycle)
  // Not required as output

  // B2_next: from B1 (always next cycle)
  // Not required as output

  // B3_next: from B2 (always next cycle)
  assign B3_next = B2;

  // Count_next: from B3, or Count stays if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next: from Count when done_counting=1, or Wait stays if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore output logic directly from current state:
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule