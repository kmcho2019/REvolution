module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = ((y[0] & w & (y[2] | y[5])) | (y[1] & w & (y[2] | y[5]))) ? 1'b1 : 1'b0;
  assign Y3 = (y[3] & w & y[4]) ? 1'b1 : 1'b0;

endmodule