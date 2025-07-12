module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,       // one-hot encoding of current state
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

  // Decode current states
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

  // Intermediate signals for next state conditions

  // Conditions for next state S
  wire S_from_S_d0    = S     & ~d;
  wire S_from_S1_d0   = S1    & ~d;
  wire S_from_S110_d0 = S110  & ~d;
  wire S_from_Wait_ack = Wait & ack;

  assign S_next = S_from_S_d0 | S_from_S1_d0 | S_from_S110_d0 | S_from_Wait_ack;

  // Condition for next state S1
  assign S1_next = S & d;

  // Condition for next state B3 (always after B2)
  assign B3_next = B2;

  // Condition for next state Count
  wire Count_stay    = Count & ~done_counting;
  wire Count_from_B3 = B3;
  assign Count_next = Count_stay | Count_from_B3;

  // Condition for next state Wait
  wire Wait_stay      = Wait & ~ack;
  wire Wait_from_Count = Count & done_counting;
  assign Wait_next = Wait_stay | Wait_from_Count;

  // Output logic - Moore outputs directly from current state
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule