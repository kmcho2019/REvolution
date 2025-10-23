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

  // Decode current state one-hot bits
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

  // Next state one-hot vector - compute only for states that affect outputs or next-state outputs
  // For states not required as next-state outputs, use minimal logic or omit from outputs
  wire [9:0] next_state;

  // Next state S (bit 0)
  // S_next <= (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);
  assign next_state[0] = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // Next state S1 (bit 1)
  // S1_next <= S & d;
  assign next_state[1] = S & d;

  // Next state S11 (bit 2)
  // S11 <= (S1 & d) | (S11); since from S11, stays if d=1, else goes to S110, so S11 with d=1
  // S11 & d or S11 & d means S11 & d; with else to S110 if d=0
  // But since S11 & d | S11 & ~d = S11 always, next state of S11 is:
  // next_state[2] = S1 & d | (S11 & d) -> we simplify to (S1 & d) | (S11 & d)
  assign next_state[2] = (S1 & d) | (S11 & d);

  // Next state S110 (bit 3)
  // next_state[3] = S11 & ~d;
  assign next_state[3] = S11 & ~d;

  // Next state B0 (bit 4)
  // next_state[4] = S110 & d;
  assign next_state[4] = S110 & d;

  // Next state B1 (bit 5)
  // next_state[5] = B0;
  assign next_state[5] = B0;

  // Next state B2 (bit 6)
  // next_state[6] = B1;
  assign next_state[6] = B1;

  // Next state B3 (bit 7)
  // next_state[7] = B2;
  assign next_state[7] = B2;

  // Next state Count (bit 8)
  // next_state[8] = B3 | (Count & ~done_counting);
  assign next_state[8] = B3 | (Count & ~done_counting);

  // Next state Wait (bit 9)
  // next_state[9] = (Count & done_counting) | (Wait & ~ack);
  assign next_state[9] = (Count & done_counting) | (Wait & ~ack);

  // Outputs from current state (Moore machine)
  // shift_ena asserted in states B0, B1, B2, B3
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting asserted in Count state
  assign counting = Count;

  // done asserted in Wait state
  assign done = Wait;

  // Export next-state signals explicitly
  assign S_next = next_state[0];
  assign S1_next = next_state[1];
  assign B3_next = next_state[7];
  assign Count_next = next_state[8];
  assign Wait_next = next_state[9];

endmodule