module TopModule (
  input        d,
  input        done_counting,
  input        ack,
  input  [9:0] state,
  output       B3_next,
  output       S_next,
  output       S1_next,
  output       Count_next,
  output       Wait_next,
  output       done,
  output       counting,
  output       shift_ena
);

  // State bits for clarity
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

  // Next state signals by inspection

  // S_next is true if next state is S
  // Possible next states to S:
  // from S if d=0
  // from S1 if d=0
  // from S11 if d=0 then S110 (No)
  // from S110 if d=0 then S
  // from Wait if ack=1 then S
  assign S_next =
       (S     & ~d)
    |  (S1    & ~d)
    |  (S110  & ~d)
    |  (Wait  &  ack);

  // S1_next is true if next state is S1
  // from S if d=1
  assign S1_next = (S & d);

  // S11_next is true if next state is S11
  // from S1 if d=1
  // from S11 if d=1
  assign S11_next = (S1 & d) | (S11 & d);

  // S110_next is true if next state is S110
  // from S11 if d=0
  assign wire_S110_next = (S11 & ~d);

  // B0_next is true if next state is B0
  // from S110 if d=1
  assign wire_B0_next = (S110 & d);

  // B1_next: always from B0
  assign wire_B1_next = B0;

  // B2_next: always from B1
  assign wire_B2_next = B1;

  // B3_next: always from B2
  assign B3_next = B2;

  // Count_next: from B3 always
  // and from Count if done_counting=0 (stays in Count)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next: from Count if done_counting=1
  // and from Wait if ack=0 (stays in Wait)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // shift_ena=1 in B0,B1,B2,B3 states (current state)
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting=1 in Count state (current state)
  assign counting = Count;

  // done=1 in Wait state (current state)
  assign done = Wait;

  // Since we need to output all next states signals, include S110_next, B0_next, B1_next, B2_next as local wires
  // But only outputs asked for: B3_next, S_next, S1_next, Count_next, Wait_next

  // The unused next states signals are generated internally for completeness
  // No output ports for S110_next, B0_next, B1_next, B2_next required.

endmodule