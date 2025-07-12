module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current one-hot states for clarity
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

  // Next-state logic (Moore FSM next states):

  // Next state S:
  // - From S, S1, S110 if d=0
  // - From Wait if ack=1
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next state S1:
  // - From S if d=1
  assign S1_next = S & d;

  // Next state B3:
  // - From B2 always
  assign B3_next = B2;

  // Next state Count:
  // - From B3 always
  // - Stay in Count while done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Next state Wait:
  // - From Count if done_counting=1
  // - Stay in Wait if ack=0
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore output logic:

  // shift_ena asserted during B0-B3 states
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting asserted in Count state
  assign counting = Count;

  // done asserted in Wait state
  assign done = Wait;

endmodule