module TopModule (
  input [4:1] x,
  output logic f
);

  // Extract individual bits for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // From the K-map analysis, the function can be expressed as:
  // f = (~x1 & ~x2 & ~x3 & ~x4)  // m0
  //   + (~x1 & ~x2 & x3 & ~x4)   // m2
  //   + (x1 & x2 & ~x3 & ~x4)    // m12
  //   + (x1 & x2 & ~x3 & x4)     // m13
  //   + (x1 & x2 & x3 & x4)      // m15
  //   + (x1 & ~x2 & ~x3 & ~x4)   // m8
  //   + (x1 & ~x2 & ~x3 & x4)    // m9
  //   + (x1 & ~x2 & x3 & ~x4);   // m10

  // Implemented as sum of minterms directly:
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