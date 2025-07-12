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

  // Current state bits (one-hot)
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

  // Next-state bits defined explicitly for all 10 states
  wire S_next_bit, S1_next_bit, S11_next_bit, S110_next_bit;
  wire B0_next_bit, B1_next_bit, B2_next_bit, B3_next_bit;
  wire Count_next_bit, Wait_next_bit;

  // Next state logic derived from transitions:

  // S state next:
  // From S: d=0 -> S, d=1 -> S1
  // From S1: d=0 -> S
  // From S11: d=1 -> S11, d=0 -> S110
  // From S110: d=0 -> S, d=1 -> B0
  // From Wait: ack=1 -> S
  assign S_next_bit = (S   & ~d)         // S,d=0->S
                    | (S1  & ~d)         // S1,d=0->S
                    | (S110 & ~d)        // S110,d=0->S
                    | (Wait &  ack);

  // S1 next:
  // From S: d=1 -> S1
  // From S1: d=1 -> S11 (handled by S11 next)
  assign S1_next_bit = (S & d);

  // S11 next:
  // From S1: d=1 -> S11
  // From S11: d=1 -> S11 (stay)
  assign S11_next_bit = (S1 & d) | (S11 & d);

  // S110 next:
  // From S11: d=0 -> S110
  assign S110_next_bit = (S11 & ~d);

  // B0 next:
  // From S110: d=1 -> B0
  assign B0_next_bit = (S110 & d);

  // B1 next:
  // From B0: always next cycle -> B1
  assign B1_next_bit = B0;

  // B2 next:
  // From B1: always next cycle -> B2
  assign B2_next_bit = B1;

  // B3 next:
  // From B2: always next cycle -> B3
  assign B3_next_bit = B2;

  // Count next:
  // From B3: always next cycle -> Count
  // From Count: done_counting=0 -> Count (stay)
  assign Count_next_bit = B3 | (Count & ~done_counting);

  // Wait next:
  // From Count: done_counting=1 -> Wait
  // From Wait: ack=0 -> Wait (stay)
  assign Wait_next_bit = (Count & done_counting) | (Wait & ~ack);

  // Outputs reflect current state (Moore outputs)
  assign done      = Wait;
  assign counting  = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

  // Assign requested next state signals from next state bits
  assign S_next     = S_next_bit;
  assign S1_next    = S1_next_bit;
  assign B3_next    = B3_next_bit;
  assign Count_next = Count_next_bit;
  assign Wait_next  = Wait_next_bit;

endmodule