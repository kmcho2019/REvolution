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

  // Decode current one-hot states
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

  // Next-state logic for states explicitly required as outputs

  // S_next:
  // from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  assign S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // S1_next:
  // from S(d=1)
  assign S1_next = S & d;

  // B3_next:
  // from B2 (always)
  assign B3_next = B2;

  // Count_next:
  // from B3 (always) or stays in Count if done_counting=0
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next:
  // from Count(done_counting=1) or stays Wait(ack=0)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Outputs (Moore): driven by current state bits
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule