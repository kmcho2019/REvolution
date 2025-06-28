module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Y1 logic
  assign Y1 = (y[0] & w & (y[1] | y[3])) ? 1'b1 : 1'b0;
  
  // Y3 logic
  assign Y3 = (y[2] & w & y[4]) ? 1'b1 : 1'b0;

endmodule