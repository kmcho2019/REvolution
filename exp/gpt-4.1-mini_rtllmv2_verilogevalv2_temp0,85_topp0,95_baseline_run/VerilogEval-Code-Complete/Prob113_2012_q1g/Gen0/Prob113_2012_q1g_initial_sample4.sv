module TopModule (
  input [4:1] x,
  output logic f
);
  // Assign variables for readability
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  assign f = 
      (~x1 & ~x2 & ~x3 & ~x4) |
      (~x1 & ~x2 &  x3 & ~x4) |
      ( x1 &  x2 & ~x3 & ~x4) |
      ( x1 &  x2 & ~x3 &  x4) |
      ( x1 &  x2 &  x3 &  x4) |
      ( x1 & ~x2 & ~x3 & ~x4) |
      ( x1 & ~x2 & ~x3 &  x4) |
      ( x1 & ~x2 &  x3 & ~x4);
endmodule