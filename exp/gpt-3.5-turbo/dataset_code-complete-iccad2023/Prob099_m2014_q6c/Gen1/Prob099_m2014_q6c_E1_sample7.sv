module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  assign Y2 = (y[3] && !y[2]) || (y[1] && (y[0] || y[4]) && !y[2]) || (y[2] && (y[0] || y[4]));
  assign Y4 = y[1] || (y[2] && y[4] && !y[3]) || (y[3] && !y[2]);

endmodule