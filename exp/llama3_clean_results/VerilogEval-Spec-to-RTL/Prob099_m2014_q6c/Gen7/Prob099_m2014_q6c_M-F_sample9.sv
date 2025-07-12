module TopModule(y, w, Y1, Y2, Y3, Y4);
  input [5:0] y;
  input w;
  output Y1;
  output Y2;
  output Y3;
  output Y4;

  // Deriving next-state signals based on the state machine transitions
  assign Y1 = (y[0] && ~w) || (y[3] && ~w) || (y[5] && w);
  assign Y2 = (y[0] && w) || (y[2] && ~w) || (y[4] && ~w);
  assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && ~w);
  assign Y4 = (y[3] && w) || (y[4] && w);

endmodule