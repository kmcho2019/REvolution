module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  assign Y2 = (y[2] == 0 && y[3]) || (y[2] == 1 && y[1]) ||
              (y[2] == 2 && y[2]) || (y[2] == 3 && y[2]) ||
              (y[2] == 4 && y[1]) || (y[2] == 5 && y[1]);

  assign Y4 = (y[4] == 0 && y[3]) || (y[4] == 1 && y[1]) ||
              (y[4] == 2 && y[2]) || (y[4] == 3 && y[1]) ||
              (y[4] == 4 && y[1]) || (y[4] == 5 && y[2]);

endmodule