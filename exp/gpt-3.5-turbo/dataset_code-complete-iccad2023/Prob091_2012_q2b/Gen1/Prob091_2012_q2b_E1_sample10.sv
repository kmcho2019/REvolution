module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Derive Y1 based on the one-hot encoding of the current state
  assign Y1 = y[2] & (y[4] | w);
  
  // Derive Y3 based on the one-hot encoding of the current state
  assign Y3 = y[0] | y[1] | y[4];

endmodule