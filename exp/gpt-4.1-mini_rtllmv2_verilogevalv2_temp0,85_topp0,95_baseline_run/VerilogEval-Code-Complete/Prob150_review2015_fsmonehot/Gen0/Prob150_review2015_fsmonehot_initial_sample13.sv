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

  // State bits index for clarity:
  // S=0, S1=1, S11=2, S110=3, B0=4, B1=5, B2=6, B3=7, Count=8, Wait=9

  // Next state logic signals
  wire S_nxt, S1_nxt, S11_nxt, S110_nxt, B0_nxt, B1_nxt, B2_nxt, B3_nxt, Count_nxt, Wait_nxt;

  // Next state logic by inspecting current state and inputs
  assign S_nxt = 
       (state[0] && d == 1'b0)    // S --d=0--> S
    || (state[1] && d == 1'b0)    // S1 --d=0--> S
    || (state[3] && d == 1'b0);   // S110 --d=0--> S

  assign S1_nxt = 
       (state[0] && d == 1'b1);    // S --d=1--> S1

  assign S11_nxt = 
       (state[1] && d == 1'b1)    // S1 --d=1--> S11
    || (state[2] && d == 1'b1);   // S11 --d=1--> S11

  assign S110_nxt = 
       (state[2] && d == 1'b0);   // S11 --d=0--> S110

  assign B0_nxt = 
       (state[3] && d == 1'b1);   // S110 --d=1--> B0

  assign B1_nxt = 
       (state[4]);                // B0 --always--> B1

  assign B2_nxt = 
       (state[5]);                // B1 --always--> B2

  assign B3_nxt = 
       (state[6]);                // B2 --always--> B3

  assign Count_nxt = 
       (state[7]);                // B3 --always--> Count

  assign Wait_nxt = 
       (state[8] && done_counting) // Count --done_counting=1--> Wait
    || (state[9] && ack == 1'b0);// Wait --ack=0--> Wait

  // Special case: Wait --ack=1--> S
  // Since Wait --ack=1--> S, add this condition to S_nxt:
  assign S_nxt = S_nxt || (state[9] && ack == 1'b1);

  // Outputs are Moore outputs from states:

  assign done = state[9];         // Wait state
  assign counting = state[8];     // Count state
  assign shift_ena = state[4] || state[5] || state[6] || state[7]; // B0,B1,B2,B3 states

  // Outputs for next state signals requested
  assign B3_next = B3_nxt;
  assign S_next = S_nxt;
  assign S1_next = S1_nxt;
  assign Count_next = Count_nxt;
  assign Wait_next = Wait_nxt;

endmodule