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

  // Intermediate conditions for next states

  // Next S conditions
  wire S_from_S    = S    & ~d;
  wire S_from_S1   = S1   & ~d;
  wire S_from_S110 = S110 & ~d;
  wire S_from_Wait = Wait & ack;
  assign S_next = S_from_S | S_from_S1 | S_from_S110 | S_from_Wait;

  // Next S1 condition
  wire S1_from_S = S & d;
  assign S1_next = S1_from_S;

  // Next S11 and S110 states are not requested as outputs, so we do not output them.
  // However, for completeness, here are the conditions (not assigned as outputs):
  // S11 next state: S1 & d, or S11 & d
  // S110 next state: S11 & ~d

  // Next B0 condition
  wire B0_from_S110 = S110 & d;

  // Next B1 condition
  wire B1_from_B0 = B0;

  // Next B2 condition
  wire B2_from_B1 = B1;

  // Next B3 condition
  wire B3_from_B2 = B2;
  assign B3_next = B3_from_B2;

  // Next Count condition
  wire Count_from_B3 = B3;
  wire Count_remain = Count & ~done_counting;
  assign Count_next = Count_from_B3 | Count_remain;

  // Next Wait condition
  wire Wait_from_Count = Count & done_counting;
  wire Wait_remain     = Wait & ~ack;
  assign Wait_next = Wait_from_Count | Wait_remain;

  // Outputs decoded from current state (Moore outputs)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule