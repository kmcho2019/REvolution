module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // next_state assignments by state and input
  assign next_state[0] = (state[0] & ~in) | (state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in) | (state[4] & ~in) | (state[7] & ~in) | (state[8] & ~in) | (state[9] & ~in);
  assign next_state[1] = (state[0] & in)  | (state[8] & in)  | (state[9] & in);
  assign next_state[2] = (state[1] & in);
  assign next_state[3] = (state[2] & in);
  assign next_state[4] = (state[3] & in);
  assign next_state[5] = (state[4] & in);
  assign next_state[6] = (state[5] & in);
  assign next_state[7] = (state[5] & ~in) | (state[7] & in);
  assign next_state[8] = (state[6] & ~in);
  assign next_state[9] = (state[6] & in);

  // outputs: out1=1 in S8 (state[8]), out2=1 in S9 (state[9]), else 0
  assign out1 = state[8];
  assign out2 = state[9];

endmodule