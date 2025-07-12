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

  // Decode current states for readability
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

  // Next-state logic (Moore FSM):

  // S_next: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  assign S_next = ((S | S1 | S110) & ~d) | (WAIT & ack);

  // S1_next: from S(d=1)
  assign S1_next = S & d;

  // B3_next: from B2 (unconditional)
  assign B3_next = B2;

  // Count_next: from B3 (unconditional) or stay in Count while done_counting=0
  assign Count_next = B3 | (COUNT & ~done_counting);

  // Wait_next: from Count(done_counting=1) or stay in Wait(ack=0)
  assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);

  // Moore outputs, based on current states:
  // shift_ena asserted in states B0,B1,B2,B3 (bits 4 to 7)
  assign shift_ena = |state[B0_BIT:B3_BIT];

  assign counting  = COUNT;
  assign done      = WAIT;

endmodule