module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,      // one-hot encoding: S=bit0 ... Wait=bit9
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

  // Next state logic derived by inspection:

  // Next state S:
  // from S, S1, S110 on d=0
  // from Wait on ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next state S1:
  // from S on d=1
  assign S1_next = S & d;

  // Next state B3:
  // from B2 unconditionally
  assign B3_next = B2;

  // Next state Count:
  // from B3 unconditionally
  // from Count while done_counting=0 (stay in Count)
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state Wait:
  // from Count when done_counting=1
  // from Wait while ack=0 (stay in Wait)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore output logic (depends only on current state):

  // done asserted in Wait
  assign done = Wait;

  // counting asserted in Count
  assign counting = Count;

  // shift_ena asserted in B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule