module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  // State encoding for clarity
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

  // Next state logic for each required next state signal

  // B3_next: next is B3 when current state is B2 (always next)
  assign B3_next = B2;

  // S_next: next state S occurs from:
  // S (d=0)
  // S1 (d=0)
  // S11 (d=0)
  // S110 (d=0)
  // Wait (ack=1)
  assign S_next = (S & ~d) 
                | (S1 & ~d) 
                | (S11 & ~d) 
                | (S110 & ~d) 
                | (Wait & ack);

  // S1_next: next is S1 from S(d=1)
  assign S1_next = S & d;

  // Count_next: next is Count from B3 (always next) or from Count(done_counting=0)
  assign Count_next = B3 | (Count & ~done_counting);

  // Wait_next: next is Wait from Count(done_counting=1)
  assign Wait_next = Count & done_counting;

  // Output logic
  assign done      = Wait;
  assign counting  = Count;
  assign shift_ena = B0 | B1 | B2 | B3;

endmodule