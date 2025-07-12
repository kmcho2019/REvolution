module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoded current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // State bits for easy reference
  localparam S_BIT     = 0;
  localparam S1_BIT    = 1;
  localparam S11_BIT   = 2;
  localparam S110_BIT  = 3;
  localparam B0_BIT    = 4;
  localparam B1_BIT    = 5;
  localparam B2_BIT    = 6;
  localparam B3_BIT    = 7;
  localparam COUNT_BIT = 8;
  localparam WAIT_BIT  = 9;

  wire S     = state[S_BIT];
  wire S1    = state[S1_BIT];
  wire S11   = state[S11_BIT];
  wire S110  = state[S110_BIT];
  wire B0    = state[B0_BIT];
  wire B1    = state[B1_BIT];
  wire B2    = state[B2_BIT];
  wire B3    = state[B3_BIT];
  wire Count = state[COUNT_BIT];
  wire Wait  = state[WAIT_BIT];

  // Next-state logic

  // Next state S:
  // From S with d=0 => S
  // From S1 with d=0 => S
  // From S110 with d=0 => S
  // From Wait with ack=1 => S
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next state S1:
  // From S with d=1 => S1
  assign S1_next = S & d;

  // Next state S11:
  // From S1 with d=1 => S11
  // Note: No output required for S11_next

  // Next state S110:
  // From S11 with d=0 => S110
  // Note: No output required for S110_next

  // Next state B0:
  // From S110 with d=1 => B0

  // Next states B1 to B3 (shift_ena=1), automatic next cycle transition
  assign B0_next = B0; // Not required as output, but for completeness if needed
  assign B1_next = B1; // Not required as output
  assign B2_next = B2; // Not required as output

  // B3_next:
  // From B2, automatic transition to B3
  assign B3_next = B2;

  // Count_next:
  // From B3 automatic to Count
  // From Count with done_counting=0 remain in Count
  assign Count_next = (B3) | (Count & ~done_counting);

  // Wait_next:
  // From Count with done_counting=1 => Wait
  // From Wait with ack=0 => Wait
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs depend only on current state
  assign done      = Wait;
  assign counting  = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule