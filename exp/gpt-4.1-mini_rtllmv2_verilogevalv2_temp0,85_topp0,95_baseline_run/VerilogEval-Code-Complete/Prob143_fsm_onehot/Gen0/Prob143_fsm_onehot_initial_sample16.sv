module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);
  // next_state logic
  assign next_state[0] = 
       (state[0] & ~in)  // S0 --0--> S0
    |  (state[1] & ~in)  // S1 --0--> S0
    |  (state[2] & ~in)  // S2 --0--> S0
    |  (state[3] & ~in)  // S3 --0--> S0
    |  (state[4] & ~in)  // S4 --0--> S0
    |  (state[7] & ~in)  // S7 --0--> S0
    |  (state[8] & ~in)  // S8 --0--> S0
    |  (state[9] & ~in); // S9 --0--> S0

  assign next_state[1] = 
       (state[0] & in)   // S0 --1--> S1
    |  (state[8] & in)  // S8 --1--> S1
    |  (state[9] & in); // S9 --1--> S1

  assign next_state[2] = (state[1] & in); // S1 --1--> S2

  assign next_state[3] = (state[2] & in); // S2 --1--> S3

  assign next_state[4] = (state[3] & in); // S3 --1--> S4

  assign next_state[5] = (state[4] & in); // S4 --1--> S5

  assign next_state[6] = (state[5] & in); // S5 --1--> S6

  assign next_state[7] = 
       (state[5] & ~in)  // S5 --0--> S8
    |  (state[7] & in);  // S7 --1--> S7

  assign next_state[8] = (state[6] & ~in); // S6 --0--> S9

  assign next_state[9] = (state[6] & in);  // S6 --1--> S7

  // output logic
  assign out1 = state[8] | state[9];   // S8(1,0) and S9(1,1)
  assign out2 = state[7] | state[9];   // S7(0,1) and S9(1,1)

endmodule