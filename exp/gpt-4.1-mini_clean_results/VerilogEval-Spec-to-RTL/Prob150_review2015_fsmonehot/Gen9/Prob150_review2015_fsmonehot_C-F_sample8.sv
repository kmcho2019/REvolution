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

  // Decode current state signals
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

  // Next-state logic intermediate signals:
  // S_next conditions (from S,d=0; S1,d=0; S110,d=0; Wait,ack=1)
  wire S_next_from_S     = S    & ~d;
  wire S_next_from_S1    = S1   & ~d;
  wire S_next_from_S110  = S110 & ~d;
  wire S_next_from_Wait  = Wait & ack;

  // S1_next condition (from S,d=1)
  wire S1_next_from_S    = S    & d;

  // B3_next condition (from B2)
  wire B3_next_from_B2   = B2;

  // Count_next conditions (from B3, or Count & ~done_counting)
  wire Count_next_from_B3      = B3;
  wire Count_next_from_Count   = Count & ~done_counting;

  // Wait_next conditions (from Count & done_counting, or Wait & ~ack)
  wire Wait_next_from_Count    = Count & done_counting;
  wire Wait_next_from_Wait     = Wait & ~ack;

  // Aggregate next-state signals
  assign S_next     = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;
  assign S1_next    = S1_next_from_S;
  assign B3_next    = B3_next_from_B2;
  assign Count_next = Count_next_from_B3 | Count_next_from_Count;
  assign Wait_next  = Wait_next_from_Count | Wait_next_from_Wait;

  // Moore outputs directly from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule