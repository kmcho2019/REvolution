module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Y1 is set when current state is A (y[0]) and input w=1 (go to B)
  assign Y1 = y[0] & w;

  // Y3 is set when current state is B (y[1]), C (y[2]), E (y[4]), or F (y[5]) and input w=0 (go to D)
  assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule