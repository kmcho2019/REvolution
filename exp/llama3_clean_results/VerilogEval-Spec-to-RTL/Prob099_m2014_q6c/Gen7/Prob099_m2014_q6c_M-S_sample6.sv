module TopModule(y, w, Y1, Y2, Y3, Y4);
  input [5:0] y;
  input w;
  output Y1;
  output Y2;
  output Y3;
  output Y4;

  // Next-state logic for Y1 (state B)
  assign Y1 = (~w & y[0]) | (~w & y[5]);

  // Next-state logic for Y2 (state C)
  assign Y2 = (~w & y[1]);

  // Next-state logic for Y3 (state D)
  assign Y3 = (~w & y[2]) | (w & y[4]) | (~w & y[4]);

  // Next-state logic for Y4 (state E)
  assign Y4 = (w & y[1]) | (w & y[3]);

endmodule