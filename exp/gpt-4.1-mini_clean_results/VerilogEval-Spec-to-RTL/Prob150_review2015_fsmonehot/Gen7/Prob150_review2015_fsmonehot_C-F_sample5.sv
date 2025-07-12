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

  // Decode current states from one-hot vector
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

  // Next-state logic for S and S1 combined, minimizing repeated terms
  wire S_next_comb = (S | S1 | S110) & ~d | (Wait & ack);
  wire S1_next_comb = S & d;

  // Next state logic for B3
  wire B3_next_comb = B2;

  // Next state logic for Count
  wire Count_next_comb = B3 | (Count & ~done_counting);

  // Next state logic for Wait
  wire Wait_next_comb = (Count & done_counting) | (Wait & ~ack);

  // Assign next state outputs
  assign S_next     = S_next_comb;
  assign S1_next    = S1_next_comb;
  assign B3_next    = B3_next_comb;
  assign Count_next = Count_next_comb;
  assign Wait_next  = Wait_next_comb;

  // Moore outputs
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule