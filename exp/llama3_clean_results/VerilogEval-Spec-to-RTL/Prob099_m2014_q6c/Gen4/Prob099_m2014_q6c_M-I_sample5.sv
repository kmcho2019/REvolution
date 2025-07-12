module TopModule(y, w, Y1, Y2, Y3, Y4);
  input [5:0] y;
  input w;
  output Y1;
  output Y2;
  output Y3;
  output Y4;

  // Y1 corresponds to state A (y[0])
  assign Y1 = (~w & y[0]) | (w & y[0]) | (~w & y[3]) | (~w & y[4]) | (w & y[5]);

  // Y2 corresponds to state B (y[1])
  assign Y2 = (~w & y[0]) | (~w & y[2]) | (~w & y[4]);

  // Y3 corresponds to state C (y[2])
  assign Y3 = (~w & y[1]) | (w & y[2]) | (w & y[5]);

  // Y4 corresponds to state D (y[3])
  assign Y4 = (w & y[0]) | (~w & y[1]) | (~w & y[2]) | (w & y[4]);
endmodule