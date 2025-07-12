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

  // Decode current states
  wire S     = state[0];
  wire S1    = state[1];
  wire S11   = state[2];
  wire S110  = state[3];
  wire B0    = state[4];
  wire B1    = state[5];
  wire B2    = state[6];
  wire B3    = state[7];
  wire Count = state[8];
  wire Wait  = state[9];

  // Next state logic

  // Next state is S when:
  // - S and d=0
  // - S1 and d=0
  // - S110 and d=0
  // - Wait and ack=1
  assign S_next = ( (S | S1 | S110) & ~d ) | (Wait & ack);

  // Next state is S1 when S and d=1
  assign S1_next = S & d;

  // Next state is B3 when B2 (always progresses)
  assign B3_next = B2;

  // Next state is Count when:
  // - From B3 (always)
  // - Staying in Count if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state is Wait when:
  // - From Count when done_counting=1
  // - Staying in Wait if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs depend only on current state

  // shift_ena is asserted in B0, B1, B2, B3 states
  assign shift_ena = |state[4:7]; // OR reduction for B0-B3

  assign counting = Count;
  assign done = Wait;

endmodule