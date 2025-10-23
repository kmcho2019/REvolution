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

  // Next state conditions for each possible next state:
  
  // Next state S: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  wire nextS_from_S     = S    & (~d);
  wire nextS_from_S1    = S1   & (~d);
  wire nextS_from_S110  = S110 & (~d);
  wire nextS_from_Wait  = Wait & ack;
  assign S_next = nextS_from_S | nextS_from_S1 | nextS_from_S110 | nextS_from_Wait;

  // Next state S1: from S(d=1)
  wire nextS1_from_S = S & d;
  assign S1_next = nextS1_from_S;

  // Next state B3: from B2 (always)
  assign B3_next = B2;

  // Next state Count: from B3 (always), or Count(done_counting=0)
  wire nextCount_from_B3      = B3;
  wire nextCount_from_Count   = Count & (~done_counting);
  assign Count_next = nextCount_from_B3 | nextCount_from_Count;

  // Next state Wait: from Count(done_counting=1), or Wait(ack=0)
  wire nextWait_from_Count = Count & done_counting;
  wire nextWait_from_Wait  = Wait & (~ack);
  assign Wait_next = nextWait_from_Count | nextWait_from_Wait;

  // Outputs (Moore machine): depend only on current states
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule