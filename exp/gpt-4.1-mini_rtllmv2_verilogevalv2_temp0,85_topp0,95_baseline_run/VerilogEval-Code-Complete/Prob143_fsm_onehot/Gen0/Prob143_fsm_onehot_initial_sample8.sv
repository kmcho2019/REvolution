module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // next_state bits logic according to transitions:
  // S0: state[0]
  // S1: state[1]
  // S2: state[2]
  // S3: state[3]
  // S4: state[4]
  // S5: state[5]
  // S6: state[6]
  // S7: state[7]
  // S8: state[8]
  // S9: state[9]

  assign next_state[0] = (state[0] & ~in)  // S0 --0--> S0
                      | (state[1] & ~in)  // S1 --0--> S0
                      | (state[2] & ~in)  // S2 --0--> S0
                      | (state[3] & ~in)  // S3 --0--> S0
                      | (state[4] & ~in)  // S4 --0--> S0
                      | (state[7] & ~in)  // S7 --0--> S0
                      | (state[8] & ~in)  // S8 --0--> S0
                      | (state[9] & ~in); // S9 --0--> S0

  assign next_state[1] = (state[0] &  in)  // S0 --1--> S1
                      | (state[8] &  in)  // S8 --1--> S1
                      | (state[9] &  in); // S9 --1--> S1

  assign next_state[2] = (state[1] &  in); // S1 --1--> S2

  assign next_state[3] = (state[2] &  in); // S2 --1--> S3

  assign next_state[4] = (state[3] &  in); // S3 --1--> S4

  assign next_state[5] = (state[4] &  in); // S4 --1--> S5

  assign next_state[6] = (state[5] &  in); // S5 --1--> S6

  assign next_state[7] = (state[5] & ~in)  // S5 --0--> S8 (check S7 next_state)
                      | (state[7] &  in); // S7 --1--> S7

  assign next_state[8] = (state[6] & ~in); // S6 --0--> S9

  assign next_state[9] = (state[6] &  in); // S6 --1--> S7 (note: S7 is next_state[7], correct this!)

  // Correction: S6 --0--> S9, S6 --1--> S7
  // So next_state[7] = (state[5] & ~in) | (state[7] & in) | (state[6] & in)
  // next_state[9] = (state[6] & ~in)

  assign next_state[7] = (state[5] & ~in) | (state[7] & in) | (state[6] & in);
  assign next_state[8] = 1'b0; // no transitions to S8 except from S5 --0--> S8 assigned above, was in next_state[7]
  assign next_state[9] = (state[6] & ~in);

  // Review transitions:
  // S5 --0--> S8  (next_state[8])
  // S5 --1--> S6  (next_state[6])
  // S6 --0--> S9  (next_state[9])
  // S6 --1--> S7  (next_state[7])
  // So next_state[8] = (state[5] & ~in);
  // next_state[9] = (state[6] & ~in);
  // next_state[7] also includes (state[7] & in) for self-loop and (state[6] & in);

  assign next_state[7] = (state[7] & in) | (state[6] & in);
  assign next_state[8] = (state[5] & ~in);
  assign next_state[9] = (state[6] & ~in);

  // Outputs from states:
  assign out1 = state[8] | state[9];
  assign out2 = state[7] | state[9];

endmodule