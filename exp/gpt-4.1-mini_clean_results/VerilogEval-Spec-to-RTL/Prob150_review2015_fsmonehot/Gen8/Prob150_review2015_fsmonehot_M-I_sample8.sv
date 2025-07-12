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

  // Decode current state bits (one-hot)
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

  // Next state logic:
  // S_next = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack)
  // Factor common (~d):
  wire d0 = ~d;
  assign S_next = (d0 & (S | S1 | S110)) | (Wait & ack);

  // S1_next = S & d
  assign S1_next = S & d;

  // B3_next = B2 (always next cycle)
  assign B3_next = B2;

  // Count_next = B3 | (Count & ~done_counting)
  wire count_stay = Count & ~done_counting;
  assign Count_next = B3 | count_stay;

  // Wait_next = (Count & done_counting) | (Wait & ~ack)
  wire wait_stay = Wait & ~ack;
  assign Wait_next = (Count & done_counting) | wait_stay;

  // Moore output logic from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule