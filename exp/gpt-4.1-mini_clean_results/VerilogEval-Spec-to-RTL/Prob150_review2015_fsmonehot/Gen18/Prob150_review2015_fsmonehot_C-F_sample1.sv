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

  // State bit indices for readability
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

  // Decode current state bits
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

  // Intermediate next-state conditions for output next states

  // S_next conditions:
  // From S with d=0
  wire S_next_from_S    = S     & (~d);
  // From S1 with d=0
  wire S_next_from_S1   = S1    & (~d);
  // From S110 with d=0
  wire S_next_from_S110 = S110  & (~d);
  // From Wait with ack=1
  wire S_next_from_Wait = Wait  & ack;

  // S1_next condition:
  // From S with d=1
  wire S1_next_from_S   = S     & d;

  // B3_next condition:
  // From B2 (always next cycle)
  wire B3_next_from_B2  = B2;

  // Count_next conditions:
  // From B3 (always next cycle)
  wire Count_next_from_B3     = B3;
  // Stay in Count while done_counting=0
  wire Count_next_stay        = Count & (~done_counting);
  wire Count_next_combined    = Count_next_from_B3 | Count_next_stay;

  // Wait_next conditions:
  // From Count when done_counting=1
  wire Wait_next_from_Count   = Count & done_counting;
  // Stay in Wait while ack=0
  wire Wait_next_stay         = Wait & (~ack);
  wire Wait_next_combined     = Wait_next_from_Count | Wait_next_stay;

  // Assign next state outputs
  assign S_next     = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;
  assign S1_next    = S1_next_from_S;
  assign B3_next    = B3_next_from_B2;
  assign Count_next = Count_next_combined;
  assign Wait_next  = Wait_next_combined;

  // Moore output logic from current states
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule