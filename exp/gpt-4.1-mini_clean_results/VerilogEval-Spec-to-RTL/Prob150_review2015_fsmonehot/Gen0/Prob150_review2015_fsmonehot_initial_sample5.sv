module TopModule (
  input        d,
  input        done_counting,
  input        ack,
  input  [9:0] state,
  output       B3_next,
  output       S_next,
  output       S1_next,
  output       Count_next,
  output       Wait_next,
  output       done,
  output       counting,
  output       shift_ena
);

  // Current states (one-hot)
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

  // Next state logic:

  // S_next:
  // From S: d=0 => S
  // From S1: d=0 => S
  // From S110: d=0 => S
  // From Wait: ack=1 => S
  assign S_next =
        (S    & ~d) 
     |  (S1   & ~d) 
     |  (S110 & ~d)
     |  (Wait  & ack);

  // S1_next:
  // From S: d=1 => S1
  assign S1_next = S & d;

  // B3_next:
  // From B2: next is B3 unconditionally
  assign B3_next = B2;

  // Count_next:
  // From B3: next is Count unconditionally
  assign Count_next = B3;

  // Wait_next:
  // From Count: done_counting=1 => Wait
  assign Wait_next = Count & done_counting;

  // Other next states (not requested) implied:
  // From S1: d=1 => S11
  // From S11: d=0 => S110, d=1 => S11
  // From S110: d=1 => B0
  // From B0: B1
  // From B1: B2
  // From Wait: ack=0 => Wait
  // From Count: done_counting=0 => Count

  // Output logic (Moore outputs):

  // shift_ena = 1 for B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting = 1 for Count
  assign counting = Count;

  // done = 1 for Wait
  assign done = Wait;

endmodule