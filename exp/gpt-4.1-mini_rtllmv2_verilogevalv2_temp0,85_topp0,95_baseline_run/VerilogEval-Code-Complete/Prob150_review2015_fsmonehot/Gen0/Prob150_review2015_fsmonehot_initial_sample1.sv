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
  localparam S    = 10'b0000000001;
  localparam S1   = 10'b0000000010;
  localparam S11  = 10'b0000000100;
  localparam S110 = 10'b0000001000;
  localparam B0   = 10'b0000010000;
  localparam B1   = 10'b0000100000;
  localparam B2   = 10'b0001000000;
  localparam B3   = 10'b0010000000;
  localparam Count= 10'b0100000000;
  localparam Wait = 10'b1000000000;

  // Next state logic signals
  wire S_next_w;
  wire S1_next_w;
  wire S11_next_w;
  wire S110_next_w;
  wire B0_next_w;
  wire B1_next_w;
  wire B2_next_w;
  wire B3_next_w;
  wire Count_next_w;
  wire Wait_next_w;

  // Current state decoded for convenience
  wire cur_S    = state[0];
  wire cur_S1   = state[1];
  wire cur_S11  = state[2];
  wire cur_S110 = state[3];
  wire cur_B0   = state[4];
  wire cur_B1   = state[5];
  wire cur_B2   = state[6];
  wire cur_B3   = state[7];
  wire cur_Count= state[8];
  wire cur_Wait = state[9];

  // Next state logic (one-hot) derived by inspection:

  // S_next:
  // From S on d=0 -> S
  // From S1 on d=0 -> S
  // From S110 on d=0 -> S
  // From Wait on ack=1 -> S
  assign S_next_w =
       (cur_S   & ~d)
    |  (cur_S1  & ~d)
    |  (cur_S110 & ~d)
    |  (cur_Wait & ack);

  // S1_next:
  // From S on d=1 -> S1
  assign S1_next_w = (cur_S & d);

  // S11_next:
  // From S1 on d=1 -> S11
  // From S11 on d=1 -> S11 (self loop)
  assign S11_next_w = (cur_S1 & d) | (cur_S11 & d);

  // S110_next:
  // From S11 on d=0 -> S110
  assign S110_next_w = (cur_S11 & ~d);

  // B0_next:
  // From S110 on d=1 -> B0
  assign B0_next_w = (cur_S110 & d);

  // B1_next:
  // From B0 unconditional -> B1
  assign B1_next_w = cur_B0;

  // B2_next:
  // From B1 unconditional -> B2
  assign B2_next_w = cur_B1;

  // B3_next:
  // From B2 unconditional -> B3
  assign B3_next_w = cur_B2;

  // Count_next:
  // From B3 unconditional -> Count
  assign Count_next_w = cur_B3;

  // Wait_next:
  // From Count on done_counting=1 -> Wait
  assign Wait_next_w = (cur_Count & done_counting);

  // Also from Count on done_counting=0 -> Count (self loop)
  // So Count_next is cur_Count & ~done_counting plus from B3
  // Redefine Count_next_w to include self loop on Count when done_counting=0
  // Already assigned from B3, add self-loop:
  wire Count_self_loop = cur_Count & ~done_counting;
  assign Count_next_w = (cur_B3) | Count_self_loop;

  // Outputs derived from current state:

  // done = 1 in Wait
  assign done = cur_Wait;

  // counting = 1 in Count
  assign counting = cur_Count;

  // shift_ena = 1 in B0, B1, B2, B3
  assign shift_ena = cur_B0 | cur_B1 | cur_B2 | cur_B3;

  // Output next state signals as required
  assign B3_next = B3_next_w;
  assign S_next = S_next_w;
  assign S1_next = S1_next_w;
  assign Count_next = Count_next_w;
  assign Wait_next = Wait_next_w;

endmodule