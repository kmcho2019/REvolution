module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoded current state: S=bit0 ... Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode states for clarity
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

  // Next-state conditions individually:
  wire S_from_S    = S & ~d;
  wire S_from_S1   = S1 & ~d;
  wire S_from_S110 = S110 & ~d;
  wire S_from_Wait = Wait & ack;

  wire S1_from_S = S & d;

  wire B3_from_B2 = B2;

  wire Count_from_B3         = B3;
  wire Count_from_Count      = Count & ~done_counting;

  wire Wait_from_Count       = Count & done_counting;
  wire Wait_from_Wait        = Wait & ~ack;

  // Assign next-state outputs (one-hot signals):
  assign S_next     = S_from_S | S_from_S1 | S_from_S110 | S_from_Wait;
  assign S1_next    = S1_from_S;
  assign B3_next    = B3_from_B2;
  assign Count_next = Count_from_B3 | Count_from_Count;
  assign Wait_next  = Wait_from_Count | Wait_from_Wait;

  // Moore outputs from current state:
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule