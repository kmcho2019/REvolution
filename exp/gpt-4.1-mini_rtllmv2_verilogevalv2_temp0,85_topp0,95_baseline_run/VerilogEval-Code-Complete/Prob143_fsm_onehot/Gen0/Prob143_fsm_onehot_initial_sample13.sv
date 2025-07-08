module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // Next state logic: one-hot encoding transitions based on input 'in'
  assign next_state[0] =  // S0 next state when input=0 from multiple states
       (~in & state[0])  // S0 --0--> S0
    | (~in & state[1])  // S1 --0--> S0
    | (~in & state[2])  // S2 --0--> S0
    | (~in & state[3])  // S3 --0--> S0
    | (~in & state[4])  // S4 --0--> S0
    | (~in & state[7])  // S7 --0--> S0
    | (~in & state[8])  // S8 --0--> S0
    | (~in & state[9]); // S9 --0--> S0

  assign next_state[1] =  // S1 next state when input=1 or transitions from S8, S9 with input=1
       (in & state[0])   // S0 --1--> S1
    | (in & state[8])   // S8 --1--> S1
    | (in & state[9]);  // S9 --1--> S1

  assign next_state[2] = (in & state[1]); // S1 --1--> S2
  assign next_state[3] = (in & state[2]); // S2 --1--> S3
  assign next_state[4] = (in & state[3]); // S3 --1--> S4
  assign next_state[5] = (in & state[4]); // S4 --1--> S5
  assign next_state[6] = (in & state[5]); // S5 --1--> S6
  assign next_state[7] = 
       (in & state[6])  // S6 --1--> S7
    | (in & state[7]); // S7 --1--> S7 (self loop)

  assign next_state[8] = (~in & state[5]); // S5 --0--> S8
  assign next_state[9] = (~in & state[6]); // S6 --0--> S9

  // Outputs are zero unless specified
  assign out1 = state[8] | state[9]; // S8(1,0), S9(1,1)
  assign out2 = state[7] | state[9]; // S7(0,1), S9(1,1)

endmodule