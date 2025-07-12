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

  // Factor common group of states that transition back to S on d=0
  wire s_group = S | S1 | S110;

  // Next state logic:

  // S_next:
  // From S, S1, or S110 on d=0; or from Wait when ack=1
  assign S_next = (~d & s_group) | (WAIT & ack);

  // S1_next:
  // From S when d=1
  assign S1_next = S & d;

  // B3_next:
  // From B2 (always next cycle)
  assign B3_next = B2;

  // Count_next:
  // From B3 (always next) or remain in Count if done_counting=0
  assign Count_next = B3 | (COUNT & ~done_counting);

  // Wait_next:
  // From Count when done_counting=1; remain in Wait if ack=0
  assign Wait_next = (COUNT & done_counting) | (WAIT & ~ack);

  // Moore output logic based on current state
  assign shift_ena = |state[7:4];  // B0 to B3 states
  assign counting  = COUNT;
  assign done      = WAIT;

endmodule