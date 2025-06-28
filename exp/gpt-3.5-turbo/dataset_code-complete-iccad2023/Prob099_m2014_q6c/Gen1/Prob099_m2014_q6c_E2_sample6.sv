module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  assign Y2 = (y[1] & ~w) | (y[3] & w); // Next state bit for y[2]
  assign Y4 = (y[3] & ~w) | (y[5] & w); // Next state bit for y[4]

endmodule