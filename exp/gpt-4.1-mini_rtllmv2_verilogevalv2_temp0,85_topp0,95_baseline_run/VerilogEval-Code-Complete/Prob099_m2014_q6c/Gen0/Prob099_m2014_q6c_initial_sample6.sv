module TopModule (
  input  [6:1] y,
  input        w,
  output       Y2,
  output       Y4
);

  // Y2 corresponds to next state B (y[2])
  // From A (y[1]) with w=0 -> B
  assign Y2 = (~w) & y[1];

  // Y4 corresponds to next state D (y[4])
  // From B (y[2]), C (y[3]), E (y[5]), F (y[6]) with w=1 -> D
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule