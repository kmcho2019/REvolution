module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // next_state[0] = S0
  // Transitions to S0:
  // S0(0) --0--> S0
  // S1(1) --0--> S0
  // S2(2) --0--> S0
  // S3(3) --0--> S0
  // S4(4) --0--> S0
  // S7(7) --0--> S0
  // S8(8) --0--> S0
  // S9(9) --0--> S0
  assign next_state[0] = (state[0] & ~in) |
                         (state[1] & ~in) |
                         (state[2] & ~in) |
                         (state[3] & ~in) |
                         (state[4] & ~in) |
                         (state[7] & ~in) |
                         (state[8] & ~in) |
                         (state[9] & ~in);

  // next_state[1] = S1
  // Transitions to S1:
  // S0(0) --1--> S1
  // S8(8) --1--> S1
  // S9(9) --1--> S1
  assign next_state[1] = (state[0] & in) |
                         (state[8] & in) |
                         (state[9] & in);

  // next_state[2] = S2
  // S1(1) --1--> S2
  assign next_state[2] = state[1] & in;

  // next_state[3] = S3
  // S2(2) --1--> S3
  assign next_state[3] = state[2] & in;

  // next_state[4] = S4
  // S3(3) --1--> S4
  assign next_state[4] = state[3] & in;

  // next_state[5] = S5
  // S4(4) --1--> S5
  assign next_state[5] = state[4] & in;

  // next_state[6] = S6
  // S5(5) --1--> S6
  assign next_state[6] = state[5] & in;

  // next_state[7] = S7
  // S6(6) --1--> S7
  // S7(7) --1--> S7
  assign next_state[7] = (state[6] & in) |
                         (state[7] & in);

  // next_state[8] = S8
  // S5(5) --0--> S8
  assign next_state[8] = state[5] & ~in;

  // next_state[9] = S9
  // S6(6) --0--> S9
  assign next_state[9] = state[6] & ~in;

  // Outputs
  // S7(7) : (0,1)
  // S8(8) : (1,0)
  // S9(9) : (1,1)
  assign out1 = state[8] | state[9];
  assign out2 = state[7] | state[9];

endmodule