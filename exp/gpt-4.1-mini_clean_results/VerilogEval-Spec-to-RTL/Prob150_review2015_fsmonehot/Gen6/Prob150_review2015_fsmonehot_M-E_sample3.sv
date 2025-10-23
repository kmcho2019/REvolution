module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,        // one-hot encoded current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Current states decoded from one-hot encoding
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

  // Next-state logic: each bit is OR of all conditions leading to that state

  // S next state conditions:
  //   S from S (d=0)
  //   S from S1 (d=0)
  //   S from S110 (d=0)
  //   S from Wait (ack=1)
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1 next state condition:
  //   S1 from S (d=1)
  assign S1_next = S & d;

  // S11 next state:
  //   S11 from S1 (d=1)
  //   S11 from S11 (d=1)
  // Note: This output is not requested explicitly as next-state output signal, so omitted

  // S110 next state:
  //   S110 from S11 (d=0)

  // B0 next state:
  //   B0 from S110 (d=1)

  // B1 next state:
  //   B1 from B0 (always)

  // B2 next state:
  //   B2 from B1 (always)

  // B3 next state:
  //   B3 from B2 (always)
  assign B3_next = B2;

  // Count next state:
  //   Count from B3 (always)
  //   Count stays if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait next state:
  //   Wait from Count if done_counting=1
  //   Wait stays if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs directly from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule