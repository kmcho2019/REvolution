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

  // State bit indices (one-hot encoding)
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

  // Current state signals
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

  // Shared conditions for next-state logic
  // S_next from S, S1, S110 with d=0, plus Wait with ack=1
  wire s_next_d0 = (S | S1 | S110) & (~d);
  wire s_next_ack = Wait & ack;

  // S_next combined
  assign S_next = s_next_d0 | s_next_ack;

  // S1_next only from S with d=1
  assign S1_next = S & d;

  // B3_next from B2 (always next cycle)
  assign B3_next = B2;

  // Count_next from B3 (always next cycle) or staying in Count with done_counting=0
  assign Count_next = B3 | (Count & (~done_counting));

  // Wait_next from Count with done_counting=1 or staying in Wait with ack=0
  assign Wait_next = (Count & done_counting) | (Wait & (~ack));

  // Moore output logic
  assign done      = Wait;
  assign counting  = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule