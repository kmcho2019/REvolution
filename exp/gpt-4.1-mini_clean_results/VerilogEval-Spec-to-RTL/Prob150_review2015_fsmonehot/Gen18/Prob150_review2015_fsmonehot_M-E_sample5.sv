module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,   // one-hot encoded current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Decode current state one-hot signals
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

  // Next state signals assigned by enumerating all transitions
  assign S_next =
         (S    & ~d)     // S + d=0 -> S
      | (S1   & ~d)     // S1 + d=0 -> S
      | (S110 & ~d)     // S110 + d=0 -> S
      | (Wait  &  ack); // Wait + ack=1 -> S

  assign S1_next =
         (S & d);        // S + d=1 -> S1

  assign B3_next =
         (B2);           // B2 -> B3 unconditionally

  assign Count_next =
         (B3)                       // B3 -> Count unconditionally
      | (Count & ~done_counting); // Count + done_counting=0 -> Count

  assign Wait_next =
         (Count & done_counting)  // Count + done_counting=1 -> Wait
      | (Wait  & ~ack);          // Wait + ack=0 -> Wait

  // Outputs (Moore outputs depend on current state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule