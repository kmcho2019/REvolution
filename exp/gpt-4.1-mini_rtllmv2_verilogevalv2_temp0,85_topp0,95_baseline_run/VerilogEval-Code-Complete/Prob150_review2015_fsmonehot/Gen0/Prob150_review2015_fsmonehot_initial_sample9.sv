module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

// State encoding for convenience (bit positions)
localparam S_idx    = 0;
localparam S1_idx   = 1;
localparam S11_idx  = 2;
localparam S110_idx = 3;
localparam B0_idx   = 4;
localparam B1_idx   = 5;
localparam B2_idx   = 6;
localparam B3_idx   = 7;
localparam Count_idx= 8;
localparam Wait_idx = 9;

// Current state one-hot signals for clarity
wire S    = state[S_idx];
wire S1   = state[S1_idx];
wire S11  = state[S11_idx];
wire S110 = state[S110_idx];
wire B0   = state[B0_idx];
wire B1   = state[B1_idx];
wire B2   = state[B2_idx];
wire B3   = state[B3_idx];
wire Count= state[Count_idx];
wire Wait = state[Wait_idx];

// Next state logic

// S_next:
// from S on d=0 stays S
// from S1 on d=0 goes S
// from S110 on d=0 goes S
// from Wait on ack=1 goes S
assign S_next =
    (S    & ~d) |
    (S1   & ~d) |
    (S110 & ~d) |
    (Wait & ack);

// S1_next:
// from S on d=1 goes S1
assign S1_next =
    (S & d);

// S11_next: (not asked to output, but needed for completeness, not required here)

// S110_next: (not asked to output, ignore)

// B0_next: (not asked)

// B1_next: (not asked)

// B2_next: (not asked)

// B3_next:
// from B2 always goes B3
assign B3_next =
    B2;

// Count_next:
// from B3 always goes Count
// from Count stays Count when done_counting=0
assign Count_next =
    B3 | (Count & ~done_counting);

// Wait_next:
// from Count goes Wait when done_counting=1
// from Wait stays Wait when ack=0
assign Wait_next =
    (Count & done_counting) |
    (Wait & ~ack);

// Outputs:

// done output asserted in Wait state
assign done = Wait;

// counting output asserted in Count state
assign counting = Count;

// shift_ena asserted in B0, B1, B2, B3 states
assign shift_ena = B0 | B1 | B2 | B3;

endmodule