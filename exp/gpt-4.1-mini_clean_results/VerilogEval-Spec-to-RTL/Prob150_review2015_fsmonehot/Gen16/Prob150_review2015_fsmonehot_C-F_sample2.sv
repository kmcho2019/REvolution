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

  // State bit indices for clarity
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

  // Next-state output logic derived by inspection and one-hot encoding

  // S_next asserted when next state is S:
  // From S with d=0
  // From S1 with d=0
  // From S110 with d=0
  // From Wait with ack=1
  assign S_next = (S & ~d)
                | (S1 & ~d)
                | (S110 & ~d)
                | (WAIT & ack);

  // S1_next asserted when next state is S1:
  // From S with d=1
  assign S1_next = (S & d);

  // B3_next asserted when next state is B3:
  // From B2 always
  assign B3_next = B2;

  // Count_next asserted when next state is Count:
  // From B3 always
  // Stay in Count while done_counting=0
  assign Count_next = (B3)
                    | (COUNT & ~done_counting);

  // Wait_next asserted when next state is Wait:
  // From Count when done_counting=1
  // Stay in Wait while ack=0
  assign Wait_next = (COUNT & done_counting)
                   | (WAIT & ~ack);

  // Moore outputs derived from current state bits
  assign done      = WAIT;
  assign counting  = COUNT;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule