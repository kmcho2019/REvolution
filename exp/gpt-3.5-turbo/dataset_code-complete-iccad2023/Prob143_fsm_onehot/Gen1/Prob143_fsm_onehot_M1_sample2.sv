module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

assign next_state = (state << 1) & {1'b0, in}; // Shift the current state left by one position and OR with the input for next state

assign out1 = (state == 10'b0010000000) | (state == 10'b1000000000); // Output out1 is 1 in states S7, S8, and S9
assign out2 = (state == 10'b0000000000) | (state == 10'b0000000001); // Output out2 is 1 in states S0 and S1

endmodule