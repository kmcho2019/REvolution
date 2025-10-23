module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot encoding of current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // State bit indices for readability and maintainability
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

  // Decode current state bits
  wire S     = state[S_BIT];
  wire S1    = state[S1_BIT];
  wire S11   = state[S11_BIT];
  wire S110  = state[S110_BIT];
  wire B0    = state[B0_BIT];
  wire B1    = state[B1_BIT];
  wire B2    = state[B2_BIT];
  wire B3    = state[B3_BIT];
  wire COUNT = state[COUNT_BIT];
  wire WAIT  = state[WAIT_BIT];

  // Common reused signals
  wire d_is_0_or_1 = d; // just alias d for clarity (not strictly needed)
  wire d0 = ~d;
  wire d1 = d;

  wire done_counting_n = ~done_counting;
  wire ack_n = ~ack;

  // Factor common OR of S, S1, S110 used for S_next
  wire S_S1_S110 = S | S1 | S110;

  // Next state logic:

  // S_next:
  // - From S with d=0
  // - From S1 with d=0
  // - From S110 with d=0
  // - From Wait with ack=1
  assign S_next = (d0 & S_S1_S110) | (WAIT & ack);

  // S1_next:
  // - From S with d=1
  assign S1_next = S & d1;

  // B3_next:
  // - From B2 (always next)
  assign B3_next = B2;

  // Count_next:
  // - From B3 (always next)
  // - Stay in Count while done_counting=0
  wire count_stay = COUNT & done_counting_n;
  assign Count_next = B3 | count_stay;

  // Wait_next:
  // - From Count when done_counting=1
  // - Stay in Wait while ack=0
  wire wait_stay = WAIT & ack_n;
  assign Wait_next = (COUNT & done_counting) | wait_stay;

  // Moore output logic (based on current state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = COUNT;
  assign done      = WAIT;

endmodule