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

  // Current states decoded
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
  // Next S state from (S, S1, S110) when d=0 and Wait when ack=1
  assign S_next = (~d & (S | S1 | S110)) | (Wait & ack);

  // Next S1 from S when d=1
  assign S1_next = S & d;

  // Next B3 from B2 (always)
  assign B3_next = B2;

  // Next Count from B3 (always) or Count while not done counting
  assign Count_next = B3 | (Count & ~done_counting);

  // Next Wait from Count when done counting or Wait while not ack
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs
  assign shift_ena = |state[7:4];  // B0 to B3 states assert shift_ena

  assign counting = Count;
  assign done = Wait;

endmodule