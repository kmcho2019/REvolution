module TopModule (
  input [4:1] x,
  output logic f
);
  // Extract bits for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // f = (x3 & ~x1) | (~x3 & x4 & x1 & x2)
  assign f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

endmodule