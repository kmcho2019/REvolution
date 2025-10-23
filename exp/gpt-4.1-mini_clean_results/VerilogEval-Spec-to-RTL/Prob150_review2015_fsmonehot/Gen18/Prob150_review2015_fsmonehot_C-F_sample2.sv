module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot encoding: bit0=S ... bit9=Wait
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // State bit indices for one-hot encoding
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

  // Decode current states for clarity and ease of logic expression
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

  // Next-state logic derived by inspection and factored for optimization

  // S_next:
  // - From states S, S1, S110 when d=0 (stay or go back to S)
  // - From WAIT when ack=1 (reset to S)
  assign S_next = (~d & (S | S1 | S110)) | (WAIT & ack);

  // S1_next:
  // - From S when d=1
  assign S1_next = S & d;

  // B3_next:
  // - From B2, always transition to B3
  assign B3_next = B2;

  // Count_next:
  // - From B3, always transition to Count
  // - Stay in Count while done_counting=0
  assign Count_next = B3 | (COUNT & ~done_counting);

  // Wait_next:
  // - From Count when done_counting=1, transition to Wait
  // - Stay in Wait if ack=0
  assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);

  // Moore outputs derived from current state bits
  assign done      = WAIT;
  assign counting  = COUNT;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule