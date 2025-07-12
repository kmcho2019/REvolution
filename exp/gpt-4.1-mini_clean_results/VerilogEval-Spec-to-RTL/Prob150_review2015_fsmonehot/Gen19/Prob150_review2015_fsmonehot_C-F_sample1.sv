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

  // State bit indices for one-hot encoding
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

  // Decode current states for clarity
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

  // Next-state logic intermediate signals

  // S_next:
  // - From S, S1, S110 when d=0
  // - From Wait when ack=1
  wire S_next_d0_states = (S | S1 | S110) & ~d;
  wire S_next = S_next_d0_states | (Wait & ack);

  // S1_next:
  // - From S when d=1
  wire S1_next = S & d;

  // B3_next:
  // - From B2 (always next cycle)
  wire B3_next = B2;

  // Count_next:
  // - From B3 (always next cycle)
  // - Stay in Count while done_counting=0
  wire Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // - From Count when done_counting=1
  // - Stay in Wait while ack=0
  wire Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Output logic (Moore outputs)
  wire shift_ena = B0 | B1 | B2 | B3;
  wire counting  = Count;
  wire done      = Wait;

  // Assign outputs
  assign B3_next    = B3_next;
  assign S_next     = S_next;
  assign S1_next    = S1_next;
  assign Count_next = Count_next;
  assign Wait_next  = Wait_next;
  assign done       = done;
  assign counting   = counting;
  assign shift_ena  = shift_ena;

endmodule