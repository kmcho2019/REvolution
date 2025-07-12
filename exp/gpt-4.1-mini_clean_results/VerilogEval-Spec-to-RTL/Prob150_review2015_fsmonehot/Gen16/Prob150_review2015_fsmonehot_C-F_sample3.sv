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

  // State bit indices
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

  // Decode current state bits for clarity
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

  // Next-state logic derived by inspection and factoring for efficiency

  // S_next: (~d & (S | S1 | S110)) | (WAIT & ack)
  assign S_next  = (~d & (S | S1 | S110)) | (WAIT & ack);

  // S1_next: S & d
  assign S1_next = S & d;

  // B3_next: B2
  assign B3_next = B2;

  // Count_next: B3 or remain in COUNT if not done counting
  assign Count_next = B3 | (COUNT & ~done_counting);

  // Wait_next: transition from COUNT on done_counting or remain in WAIT if ack=0
  assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);

  // Outputs (Moore outputs assigned from current states)
  assign done      = WAIT;
  assign counting  = COUNT;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule