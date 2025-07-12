module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,
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
  wire S    = state[0];
  wire S1   = state[1];
  wire S11  = state[2];
  wire S110 = state[3];
  wire B0   = state[4];
  wire B1   = state[5];
  wire B2   = state[6];
  wire B3   = state[7];
  wire Count = state[8];
  wire Wait = state[9];

  // Intermediate next state conditions

  // Next S: from S(d=0), S1(d=0), S110(d=0), Wait(ack=1)
  wire nextS_from_S   = S    & (~d);
  wire nextS_from_S1  = S1   & (~d);
  wire nextS_from_S110= S110 & (~d);
  wire nextS_from_Wait= Wait & ack;
  assign S_next = nextS_from_S | nextS_from_S1 | nextS_from_S110 | nextS_from_Wait;

  // Next S1: from S(d=1)
  assign S1_next = S & d;

  // Next S11: (not output requested but needed internally for clarity)
  // Not output requested, so omitted.

  // Next S110: (not output requested but needed internally)
  // Not output requested, so omitted.

  // B0_next: from S110(d=1)
  wire B0_next = S110 & d;

  // B1_next: from B0 (always next cycle)
  wire B1_next = B0;

  // B2_next: from B1 (always next cycle)
  wire B2_next = B1;

  // B3_next: from B2 (always next cycle)
  assign B3_next = B2;

  // Count_next: from B3 and Count(not done_counting)
  assign Count_next = B3 | (Count & (~done_counting));

  // Wait_next: from Count(done_counting) and Wait(not ack)
  assign Wait_next = (Count & done_counting) | (Wait & (~ack));

  // Moore output logic according to current state

  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule