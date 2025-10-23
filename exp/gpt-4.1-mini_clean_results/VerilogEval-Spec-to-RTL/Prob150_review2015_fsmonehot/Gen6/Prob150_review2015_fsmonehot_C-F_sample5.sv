module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded current state
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

  // Next-state intermediate conditions (for clarity and scalability)
  wire next_S_from_S      = S     & ~d;
  wire next_S_from_S1     = S1    & ~d;
  wire next_S_from_S110   = S110  & ~d;
  wire next_S_from_Wait   = Wait  & ack;

  wire next_S1_from_S     = S     & d;

  wire next_B3_from_B2    = B2;

  wire next_Count_from_B3 = B3;
  wire next_Count_stay    = Count & ~done_counting;

  wire next_Wait_from_Count = Count & done_counting;
  wire next_Wait_stay       = Wait & ~ack;

  // Combine next state assignments
  assign S_next     = next_S_from_S | next_S_from_S1 | next_S_from_S110 | next_S_from_Wait;
  assign S1_next    = next_S1_from_S;
  assign B3_next    = next_B3_from_B2;
  assign Count_next = next_Count_from_B3 | next_Count_stay;
  assign Wait_next  = next_Wait_from_Count | next_Wait_stay;

  // Moore output logic from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule