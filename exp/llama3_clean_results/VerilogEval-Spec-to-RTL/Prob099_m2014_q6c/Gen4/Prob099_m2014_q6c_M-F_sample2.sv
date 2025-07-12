module TopModule(y, w, Y1, Y3);
  input [5:0] y;
  input w;
  output Y1;
  output Y3;

  assign Y1 = (y[0] & ~w) | (y[3] & w) | (y[5] & w);
  assign Y3 = (y[1] & ~w) | (y[5] & ~w);

  // Next-state signals Y2 and Y4 for reference
  // assign Y2 = (y[0] & w);
  // assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & ~w) | (y[5] & ~w);
endmodule