module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // Next state logic
  assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9])) |
                         (in & state[5] & ~state[6]) |  // S5 with input 0 goes to S8
                         (in & state[6] & ~state[5]);   // S6 with input 0 goes to S9

  assign next_state[1] = (in & (state[0] | state[8] | state[9]));  // From S0/S8/S9 with 1
  assign next_state[2] = (in & state[1]);  // From S1 with 1
  assign next_state[3] = (in & state[2]);  // From S2 with 1
  assign next_state[4] = (in & state[3]);  // From S3 with 1
  assign next_state[5] = (in & state[4]);  // From S4 with 1
  assign next_state[6] = (in & state[5]);  // From S5 with 1
  assign next_state[7] = (in & (state[6] | state[7]));  // From S6 or S7 with 1
  assign next_state[8] = (~in & state[5]);  // From S5 with 0
  assign next_state[9] = (~in & state[6]);  // From S6 with 0

  // Output logic
  assign out1 = state[8] | state[9];  // S8 or S9 have out1=1
  assign out2 = state[7] | state[9];  // S7 or S9 have out2=1

endmodule