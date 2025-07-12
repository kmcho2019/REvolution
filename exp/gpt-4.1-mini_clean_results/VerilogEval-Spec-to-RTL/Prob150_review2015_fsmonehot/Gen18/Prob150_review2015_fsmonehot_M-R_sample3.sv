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

  // Next state signals derived from current state and inputs
  wire S_next_from_S     = (d == 1'b0) ? 1'b1 : 1'b0;       // S -> S if d=0
  wire S1_next_from_S    = (d == 1'b1) ? 1'b1 : 1'b0;       // S -> S1 if d=1

  wire S_next_from_S1    = (d == 1'b0) ? 1'b1 : 1'b0;       // S1 -> S if d=0
  wire S11_next_from_S1  = (d == 1'b1) ? 1'b1 : 1'b0;       // S1 -> S11 if d=1

  wire S11_next_from_S11 = (d == 1'b1) ? 1'b1 : 1'b0;       // S11 -> S11 if d=1
  wire S110_next_from_S11= (d == 1'b0) ? 1'b1 : 1'b0;       // S11 -> S110 if d=0

  wire S_next_from_S110  = (d == 1'b0) ? 1'b1 : 1'b0;       // S110 -> S if d=0
  wire B0_next_from_S110 = (d == 1'b1) ? 1'b1 : 1'b0;       // S110 -> B0 if d=1

  wire B1_next_from_B0   = 1'b1;                            // B0 -> B1 always
  wire B2_next_from_B1   = 1'b1;                            // B1 -> B2 always
  wire B3_next_from_B2   = 1'b1;                            // B2 -> B3 always
  wire Count_next_from_B3= 1'b1;                            // B3 -> Count always

  wire Count_next_from_Count   = (done_counting == 1'b0) ? 1'b1 : 1'b0; // Count -> Count if !done_counting
  wire Wait_next_from_Count    = (done_counting == 1'b1) ? 1'b1 : 1'b0; // Count -> Wait if done_counting

  wire Wait_next_from_Wait     = (ack == 1'b0) ? 1'b1 : 1'b0;          // Wait -> Wait if ack=0
  wire S_next_from_Wait        = (ack == 1'b1) ? 1'b1 : 1'b0;          // Wait -> S if ack=1

  // Aggregate next state signals by OR-ing contributions from each current state
  assign S_next = (S & S_next_from_S) | (S1 & S_next_from_S1) | (S110 & S_next_from_S110) | (Wait & S_next_from_Wait);
  assign S1_next = S & S1_next_from_S;
  assign B3_next = B2 & B3_next_from_B2;
  assign Count_next = (B3 & Count_next_from_B3) | (Count & Count_next_from_Count);
  assign Wait_next = (Count & Wait_next_from_Count) | (Wait & Wait_next_from_Wait);

  // Outputs from current state
  assign shift_ena = |state[7:4]; // B0-B3
  assign counting = Count;
  assign done = Wait;

endmodule