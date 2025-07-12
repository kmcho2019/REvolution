module TopModule(
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,       // one-hot current state vector
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

  // State bit positions
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

  // Current states
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

  // Next state vector, one bit per state
  wire [9:0] next_state;

  // Next state assignments:
  // S_next logic:
  // From S, d=0 -> S
  // From S1, d=0 -> S
  // From S110, d=0 -> S
  // From Wait, ack=1 -> S
  assign next_state[S_bit] = (S & ~d)
                           | (S1 & ~d)
                           | (S110 & ~d)
                           | (Wait & ack);

  // S1_next logic:
  // From S, d=1 -> S1
  assign next_state[S1_bit] = (S & d);

  // S11_next:
  // From S1, d=1 -> S11
  assign next_state[S11_bit] = (S1 & d)
                            // From S11, d=1 -> S11 (loop)
                            | (S11 & d);

  // S110_next:
  // From S11, d=0 -> S110
  assign next_state[S110_bit] = (S11 & ~d);

  // B0_next:
  // From S110, d=1 -> B0
  assign next_state[B0_bit] = (S110 & d);

  // B1_next:
  // From B0 -> B1 (always next)
  assign next_state[B1_bit] = B0;

  // B2_next:
  // From B1 -> B2 (always next)
  assign next_state[B2_bit] = B1;

  // B3_next:
  // From B2 -> B3 (always next)
  assign next_state[B3_bit] = B2;

  // Count_next:
  // From B3 -> Count (always next)
  // Count stays in Count when done_counting=0
  assign next_state[Count_bit] = (B3)
                              | (Count & ~done_counting);

  // Wait_next:
  // From Count, done_counting=1 -> Wait
  // Wait stays in Wait when ack=0
  assign next_state[Wait_bit] = (Count & done_counting)
                             | (Wait & ~ack);

  // Output next-state signals directly from next_state vector
  assign S_next     = next_state[S_bit];
  assign S1_next    = next_state[S1_bit];
  assign B3_next    = next_state[B3_bit];
  assign Count_next = next_state[Count_bit];
  assign Wait_next  = next_state[Wait_bit];

  // Moore outputs derived from current state bits
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule