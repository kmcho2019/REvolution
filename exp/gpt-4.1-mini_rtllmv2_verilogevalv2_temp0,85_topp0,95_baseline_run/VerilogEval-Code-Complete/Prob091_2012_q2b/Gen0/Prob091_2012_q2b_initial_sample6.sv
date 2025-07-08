module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Y1 is next state input for B: from A if w=1
  assign Y1 = y[0] & w;

  // Y3 is next state input for D: from B,C,E,F if w=0
  assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule