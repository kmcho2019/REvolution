module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,        // one-hot encoding of current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Current states decoded for readability
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

  // Next state logic (one-hot), each next state assigned by OR of all possible transitions

  // Next S:
  // From S when d=0
  // From S1 when d=0
  // From S110 when d=0
  // From Wait when ack=1
  assign S_next = (S    & ~d) |
                  (S1   & ~d) |
                  (S110 & ~d) |
                  (Wait & ack);

  // Next S1:
  // From S when d=1
  assign S1_next = S & d;

  // Next S11:
  // From S1 when d=1
  assign /* unused output, but can be declared internally if needed */ S11_next_dummy = S1 & d;

  // Next S110:
  // From S11 when d=0
  assign /* unused output, can be internal */ S110_next_dummy = S11 & ~d;

  // Next B0:
  // From S110 when d=1
  assign /* unused output */ B0_next_dummy = S110 & d;

  // Next B1:
  // From B0 unconditionally
  assign /* unused output */ B1_next_dummy = B0;

  // Next B2:
  // From B1 unconditionally
  assign /* unused output */ B2_next_dummy = B1;

  // Next B3:
  // From B2 unconditionally
  assign B3_next = B2;

  // Next Count:
  // From B3 unconditionally
  // From Count when done_counting=0 (stay in Count)
  assign Count_next = B3 | (Count & ~done_counting);

  // Next Wait:
  // From Count when done_counting=1
  // From Wait when ack=0 (stay in Wait)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs are Moore outputs derived from current state (not next state)
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule