module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Determine the transitions for Y1 based on the state changes on bits y[0] and y[1]
  assign Y1 = (y[0] & ~y[1] & w) | (~y[0] & y[1] & ~w);

  // Determine the transitions for Y3 based on the state changes on bits y[1] and y[2]
  assign Y3 = (y[1] & ~y[2] & ~w) | (~y[1] & y[2] & w);

endmodule