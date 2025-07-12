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

  // Next-state intermediate conditions
  wire S_next_from_S_d0    = S    & ~d;
  wire S_next_from_S1_d0   = S1   & ~d;
  wire S_next_from_S110_d0 = S110 & ~d;
  wire S_next_from_Wait_ack= Wait & ack;

  wire S1_next_from_S_d1   = S & d;

  wire B3_next_from_B2     = B2;

  wire Count_next_from_B3          = B3;
  wire Count_next_stay             = Count & ~done_counting;
  wire Count_next_combined         = Count_next_from_B3 | Count_next_stay;

  wire Wait_next_from_Count_done   = Count & done_counting;
  wire Wait_next_stay              = Wait & ~ack;
  wire Wait_next_combined          = Wait_next_from_Count_done | Wait_next_stay;

  // Assign next state outputs
  assign S_next     = S_next_from_S_d0 | S_next_from_S1_d0 | S_next_from_S110_d0 | S_next_from_Wait_ack;
  assign S1_next    = S1_next_from_S_d1;
  assign B3_next    = B3_next_from_B2;
  assign Count_next = Count_next_combined;
  assign Wait_next  = Wait_next_combined;

  // Moore outputs from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule