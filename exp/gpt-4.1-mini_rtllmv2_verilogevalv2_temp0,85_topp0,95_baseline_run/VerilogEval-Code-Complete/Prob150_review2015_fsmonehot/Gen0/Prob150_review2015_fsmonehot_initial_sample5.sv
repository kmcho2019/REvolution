module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  // State encoding indices for clarity
  localparam S    = 0; // 10'b0000000001
  localparam S1   = 1; // 10'b0000000010
  localparam S11  = 2; // 10'b0000000100
  localparam S110 = 3; // 10'b0000001000
  localparam B0   = 4; // 10'b0000010000
  localparam B1   = 5; // 10'b0000100000
  localparam B2   = 6; // 10'b0001000000
  localparam B3   = 7; // 10'b0010000000
  localparam Count= 8; // 10'b0100000000
  localparam Wait = 9; // 10'b1000000000

  // Current state one-hot signals for convenience
  wire s_S    = state[S];
  wire s_S1   = state[S1];
  wire s_S11  = state[S11];
  wire s_S110 = state[S110];
  wire s_B0   = state[B0];
  wire s_B1   = state[B1];
  wire s_B2   = state[B2];
  wire s_B3   = state[B3];
  wire s_Count= state[Count];
  wire s_Wait = state[Wait];

  // Next state logic for each next state output

  // B3_next:
  // B2 --(always)--> B3
  assign B3_next = s_B2;

  // S_next:
  // S --d=0--> S
  // S1 --d=0--> S
  // S110 --d=0--> S
  // S110 --d=0--> S
  // Wait --ack=1--> S
  assign S_next =
       (s_S    & ~d)    // from S with d=0
    |  (s_S1   & ~d)    // from S1 with d=0
    |  (s_S110 & ~d)    // from S110 with d=0
    |  (s_Wait & ack);  // from Wait with ack=1

  // S1_next:
  // S --d=1--> S1
  assign S1_next = s_S & d;

  // Count_next:
  // B3 --(always)--> Count
  assign Count_next = s_B3;

  // Wait_next:
  // Count --done_counting=1--> Wait
  assign Wait_next = s_Count & done_counting;

  // Output logic

  // done=1 in Wait state only
  assign done = s_Wait;

  // counting=1 in Count state only
  assign counting = s_Count;

  // shift_ena=1 in B0 to B3 states
  assign shift_ena = s_B0 | s_B1 | s_B2 | s_B3;

endmodule