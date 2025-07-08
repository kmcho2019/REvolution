module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

  // One-hot current state bits
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

  // Next state logic (one-hot encoded)
  // From S:
  wire S_next_from_S  = S  & ~d;
  wire S1_next_from_S = S  & d;

  // From S1:
  wire S_next_from_S1  = S1 & ~d;
  wire S11_next_from_S1 = S1 & d;

  // From S11:
  wire S110_next_from_S11 = S11 & ~d;
  wire S11_next_from_S11  = S11 & d;

  // From S110:
  wire S_next_from_S110 = S110 & ~d;
  wire B0_next_from_S110 = S110 & d;

  // From B states: always advance
  wire B1_next_from_B0 = B0;
  wire B2_next_from_B1 = B1;
  wire B3_next_from_B2 = B2;
  wire Count_next_from_B3 = B3;

  // From Count:
  wire Count_next_from_Count = Count & ~done_counting;
  wire Wait_next_from_Count  = Count & done_counting;

  // From Wait:
  wire Wait_next_from_Wait = Wait & ~ack;
  wire S_next_from_Wait    = Wait & ack;

  // Aggregate next states
  assign S_next    = S_next_from_S | S_next_from_S1 | S_next_from_S110 | S_next_from_Wait;
  assign S1_next   = S1_next_from_S;
  assign S11_next  = S11_next_from_S1 | S11_next_from_S11;
  wire S11_next; // internal signal required for completeness - not an output
  assign S11_next = S11_next_from_S1 | S11_next_from_S11;

  assign S110_next = S110_next_from_S11;

  assign B0_next   = B0_next_from_S110;

  assign B1_next   = B1_next_from_B0;
  assign B2_next   = B2_next_from_B1;
  assign B3_next   = B3_next_from_B2;

  assign Count_next = Count_next_from_B3 | Count_next_from_Count;
  assign Wait_next  = Wait_next_from_Count | Wait_next_from_Wait;

  // Outputs
  assign shift_ena = B0 | B1 | B2 | B3;
  assign counting  = Count;
  assign done      = Wait;

endmodule