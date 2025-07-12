module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // one-hot encoded current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Current state bits for clarity
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

  // Next state bits computed combinationally by inspecting transitions

  // next_S: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  wire next_S = (S & ~d) | (S1 & ~d) | (S110 & ~d) | (Wait & ack);

  // next_S1: from S(d=1)
  wire next_S1 = S & d;

  // next_S11: from S1(d=1) or S11(d=1)
  wire next_S11 = (S1 & d) | (S11 & d);

  // next_S110: from S11(d=0)
  wire next_S110 = S11 & ~d;

  // next_B0: from S110(d=1)
  wire next_B0 = S110 & d;

  // next_B1: from B0 (always)
  wire next_B1 = B0;

  // next_B2: from B1 (always)
  wire next_B2 = B1;

  // next_B3: from B2 (always)
  wire next_B3 = B2;

  // next_Count: from B3 (always), or remain in Count if done_counting=0
  wire next_Count = B3 | (Count & ~done_counting);

  // next_Wait: from Count(done_counting=1), or remain Wait(ack=0)
  wire next_Wait = (Count & done_counting) | (Wait & ~ack);

  // Combine all next state bits into a vector for completeness
  wire [9:0] next_state = {
    next_Wait,    // bit 9
    next_Count,   // bit 8
    next_B3,      // bit 7
    next_B2,      // bit 6
    next_B1,      // bit 5
    next_B0,      // bit 4
    next_S110,    // bit 3
    next_S11,     // bit 2
    next_S1,      // bit 1
    next_S        // bit 0
  };

  // Outputs requested per problem statement
  assign B3_next   = next_B3;
  assign S_next    = next_S;
  assign S1_next   = next_S1;
  assign Count_next= next_Count;
  assign Wait_next = next_Wait;

  // Outputs per Moore machine current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule