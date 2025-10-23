module TopModule(
  input  wire        d,
  input  wire        done_counting,
  input  wire        ack,
  input  wire [9:0]  state,       // one-hot encoded current state vector

  output wire        B3_next,
  output wire        S_next,
  output wire        S1_next,
  output wire        Count_next,
  output wire        Wait_next,
  output wire        done,
  output wire        counting,
  output wire        shift_ena
);

  // State bits in one-hot vector (index): 
  // S=0, S1=1, S11=2, S110=3, B0=4, B1=5, B2=6, B3=7, Count=8, Wait=9
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

  // Next state logic - derived directly from FSM transitions

  // S_next:
  // From S when d=0
  // From S1 when d=0
  // From S110 when d=0
  // From Wait when ack=1
  assign S_next = (S & ~d) 
                | (S1 & ~d) 
                | (S110 & ~d) 
                | (Wait & ack);

  // S1_next:
  // From S when d=1
  assign S1_next = (S & d);

  // B3_next:
  // From B2 always
  assign B3_next = B2;

  // Count_next:
  // From B3 always
  // From Count while done_counting=0 (stay in Count)
  assign Count_next = (B3) 
                    | (Count & ~done_counting);

  // Wait_next:
  // From Count when done_counting=1
  // Stay in Wait while ack=0
  assign Wait_next = (Count & done_counting) 
                   | (Wait & ~ack);

  // Moore output signals directly from current state
  assign shift_ena = B0 | B1 | B2 | B3;  // asserted in B0-B3
  assign counting  = Count;               // asserted in Count
  assign done      = Wait;                // asserted in Wait

endmodule