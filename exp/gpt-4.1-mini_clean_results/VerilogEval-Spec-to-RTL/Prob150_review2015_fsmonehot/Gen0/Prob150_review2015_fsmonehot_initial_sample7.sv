module TopModule (
  input        d,
  input        done_counting,
  input        ack,
  input [9:0]  state,        // one-hot encoded current state input
  output       B3_next,
  output       S_next,
  output       S1_next,
  output       Count_next,
  output       Wait_next,
  output       done,
  output       counting,
  output       shift_ena
);

  // One-hot states index (for clarity)
  // S     = 10'b0000000001 = bit 0
  // S1    = 10'b0000000010 = bit 1
  // S11   = 10'b0000000100 = bit 2
  // S110  = 10'b0000001000 = bit 3
  // B0    = 10'b0000010000 = bit 4
  // B1    = 10'b0000100000 = bit 5
  // B2    = 10'b0001000000 = bit 6
  // B3    = 10'b0010000000 = bit 7
  // Count = 10'b0100000000 = bit 8
  // Wait  = 10'b1000000000 = bit 9

  wire S    = state[0];
  wire S1   = state[1];
  wire S11  = state[2];
  wire S110 = state[3];
  wire B0   = state[4];
  wire B1   = state[5];
  wire B2   = state[6];
  wire B3   = state[7];
  wire Count= state[8];
  wire Wait = state[9];

  // Next state logic by inspection of the transition diagram

  // S_next:
  // From S: d=0 -> S
  // From S1: d=0 -> S
  // From S110: d=0 -> S
  // From Wait: ack=1 -> S
  assign S_next =
         (S   & ~d)     // S, d=0
       | (S1  & ~d)     // S1, d=0
       | (S110 & ~d)    // S110, d=0
       | (Wait &  ack); // Wait, ack=1

  // S1_next:
  // From S: d=1 -> S1
  assign S1_next = (S & d);

  // B3_next:
  // From B2: always next to B3
  assign B3_next = B2;

  // Count_next:
  // From B3: next cycle -> Count
  // From Count: done_counting=0 -> Count (stay)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // From Count: done_counting=1 -> Wait
  // From Wait: ack=0 -> Wait (stay)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Output logic (Moore outputs depend on current state only)

  // done = 1 when Wait
  assign done = Wait;

  // counting = 1 when Count
  assign counting = Count;

  // shift_ena = 1 in states B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule