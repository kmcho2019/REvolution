module TopModule (
  input        d,
  input        done_counting,
  input        ack,
  input  [9:0] state,       // one-hot encoded current state
  output       B3_next,
  output       S_next,
  output       S1_next,
  output       Count_next,
  output       Wait_next,
  output       done,
  output       counting,
  output       shift_ena
);

  // State encoding for clarity:
  // S    = 10'b0000000001 = state[0]
  // S1   = 10'b0000000010 = state[1]
  // S11  = 10'b0000000100 = state[2]
  // S110 = 10'b0000001000 = state[3]
  // B0   = 10'b0000010000 = state[4]
  // B1   = 10'b0000100000 = state[5]
  // B2   = 10'b0001000000 = state[6]
  // B3   = 10'b0010000000 = state[7]
  // Count =10'b0100000000 = state[8]
  // Wait  =10'b1000000000 = state[9]

  // Next state signals (one-hot) for selected states
  // Compute each next state based on current state and inputs

  // Next S:
  // From S, if d=0 => S
  // From S1, if d=0 => S
  // From S110, if d=0 => S
  // From Wait, if ack=1 => S
  wire S_next_w = 
       (state[0] & ~d)       // S + d=0
    |  (state[1] & ~d)       // S1 + d=0
    |  (state[3] & ~d)       // S110 + d=0
    |  (state[9] & ack);     // Wait + ack=1

  // Next S1:
  // From S, if d=1 => S1
  wire S1_next_w = (state[0] & d);

  // Next S11:
  // From S1, if d=1 => S11
  // Note: S11_next is not requested as output

  // Next S110:
  // From S11, if d=0 => S110
  // Note: S110_next is not requested as output

  // Next B0:
  // From S110, if d=1 => B0
  // Note: B0_next not requested

  // Next B1:
  // From B0 always => B1
  // Not requested

  // Next B2:
  // From B1 always => B2
  // Not requested

  // Next B3:
  // From B2 always => B3
  wire B3_next_w = (state[6]); // B2 always to B3

  // Next Count:
  // From B3 always => Count
  wire Count_next_w = (state[7]);

  // From Count:
  // done_counting=0 => Count
  // done_counting=1 => Wait
  wire Count_stay = (state[8] & ~done_counting);
  wire Wait_next_w = (state[8] & done_counting);
  
  // From Wait:
  // ack=0 => Wait
  // ack=1 => S (already in S_next_w)
  wire Wait_stay = (state[9] & ~ack);

  // Assign outputs for next state signals:
  // Note: S_next, S1_next, B3_next, Count_next, Wait_next are asserted when next state equals that state.
  // For Wait_next we only assert when moving from Count to Wait.
  // Wait also stays in Wait if ack=0, but Wait_next is defined as going to Wait from Count, so only transition.
  // So Wait_next = Count->Wait transition only.

  // done output: done=1 in Wait state
  assign done = state[9];

  // counting output: counting=1 in Count state
  assign counting = state[8];

  // shift_ena: asserted in B0, B1, B2, B3 states
  assign shift_ena = |(state[4:7]); // states B0 to B3

  assign S_next      = S_next_w;
  assign S1_next     = S1_next_w;
  assign B3_next     = B3_next_w;
  assign Count_next  = Count_next_w;
  assign Wait_next   = Wait_next_w;

endmodule