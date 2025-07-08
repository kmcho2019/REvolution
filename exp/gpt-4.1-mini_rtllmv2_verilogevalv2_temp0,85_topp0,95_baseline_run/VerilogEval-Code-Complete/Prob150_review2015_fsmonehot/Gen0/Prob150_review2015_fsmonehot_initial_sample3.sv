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

  // State encoding bits for clarity
  wire S    = state[0];
  wire S1   = state[1];
  wire S11  = state[2];
  wire S110 = state[3];
  wire B0   = state[4];
  wire B1   = state[5];
  wire B2   = state[6];
  wire B3   = state[7];
  wire Count = state[8];
  wire Wait  = state[9];

  // Next state logic equations:
  // From S:
  //   d=0 -> S
  //   d=1 -> S1
  wire S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
  // From S1:
  //   d=0 -> S
  //   d=1 -> S11
  wire S1_next = S & d;

  // From S11:
  //   d=0 -> S110
  //   d=1 -> S11
  wire S11_next = S11 & d;

  // From S110:
  //   d=0 -> S
  //   d=1 -> B0
  wire S110_next = S11 & ~d;

  // From B0:
  //   always -> B1
  wire B0_next = B0;

  // From B1:
  //   always -> B2
  wire B1_next = B1;

  // From B2:
  //   always -> B3
  wire B2_next = B2;

  // From B3:
  //   always -> Count
  wire B3_next = B2;

  // From Count:
  //   done_counting=0 -> Count
  //   done_counting=1 -> Wait
  wire Count_next = B3 & ~done_counting;

  // From Wait:
  //   ack=0 -> Wait
  //   ack=1 -> S
  wire Wait_next = Count & done_counting;

  // Correct next state signals (as outputs) per problem statement:

  // Next state B3 is true when current state is B2 (B2 -> B3 always)
  assign B3_next = B2;

  // Next state S is true when:
  // - from S with d=0
  // - from S1 with d=0
  // - from S110 with d=0
  // - from Wait with ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next state S1 is true when current state S with d=1
  assign S1_next = S & d;

  // Next state Count is true when current state B3 (B3 -> Count)
  assign Count_next = B3;

  // Next state Wait is true when current state Count with done_counting=1
  assign Wait_next = Count & done_counting;

  // Output logic (Moore outputs depend only on current state):

  // done=1 only in Wait state
  assign done = Wait;

  // counting=1 only in Count state
  assign counting = Count;

  // shift_ena=1 in states B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule