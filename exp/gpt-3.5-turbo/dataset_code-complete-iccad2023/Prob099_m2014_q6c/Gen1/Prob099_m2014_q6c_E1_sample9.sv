module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = y[1] ^ w; // Next state for Y2 (y[2])
assign Y4 = y[3] ^ w; // Next state for Y4 (y[4])

endmodule