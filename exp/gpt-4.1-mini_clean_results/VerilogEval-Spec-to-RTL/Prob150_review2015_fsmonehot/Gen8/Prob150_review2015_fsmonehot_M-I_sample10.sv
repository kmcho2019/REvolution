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

  // Decode current state bits
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

  // Common term for S_next: any of S, S1, S110 with d=0
  wire d0_from_S_states = ~d & (S | S1 | S110);

  // Next state logic optimized by factoring:
  // S_next asserted if:
  // - (S|S1|S110) & d=0
  // - Wait & ack
  assign S_next = d0_from_S_states | (Wait & ack);

  // S1_next asserted if S & d=1
  assign S1_next = S & d;

  // B3_next simply follows B2 (always advance in B states)
  assign B3_next = B2;

  // Count_next asserted if B3 or Count (when not done_counting)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next asserted if Count (done_counting) or Wait (~ack)
  assign Wait_next = (Count & done_counting) | (Wait & ~ack);

  // Moore outputs depend only on current state
  // shift_ena asserted during B0, B1, B2, B3
  wire in_B_states = B0 | B1 | B2 | B3;
  assign shift_ena = in_B_states;
  assign counting  = Count;
  assign done      = Wait;

endmodule