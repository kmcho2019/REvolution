module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,   // one-hot encoding of current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Unpack current state bits for readability
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

  // Compute next-state signals

  // Next state is S if:
  // from S,d=0; from S1,d=0; from S110,d=0; from Wait, ack=1
  assign S_next =
         (S    & ~d)
       | (S1   & ~d)
       | (S110 & ~d)
       | (Wait &  ack);

  // Next state is S1 if:
  // from S,d=1
  assign S1_next = S & d;

  // Next state is B3 if:
  // from B2 (always)
  assign B3_next = B2;

  // Next state is Count if:
  // from B3 (always) or remain in Count if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state is Wait if:
  // from Count if done_counting=1 or remain in Wait if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs asserted in specific current states (Moore outputs)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule