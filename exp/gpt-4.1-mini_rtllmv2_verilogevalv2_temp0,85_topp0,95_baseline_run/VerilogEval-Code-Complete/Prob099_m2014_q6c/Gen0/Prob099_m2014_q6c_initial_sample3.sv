module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Next state bit for B (y[2])
  assign Y2 = y[1] & ~w;

  // Next state bit for D (y[4])
  assign Y4 = (y[2] | y[3] | y[5] | y[6]) & w;

endmodule