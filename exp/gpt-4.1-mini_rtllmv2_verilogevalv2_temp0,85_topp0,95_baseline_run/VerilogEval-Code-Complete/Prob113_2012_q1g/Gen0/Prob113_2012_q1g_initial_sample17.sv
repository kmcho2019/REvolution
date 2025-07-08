module TopModule (
  input  [4:1] x,
  output logic f
);

  // Assign individual bits to meaningful names for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // Implement the function f based on the minterms derived from Karnaugh map
  assign f =
      (~x1 & ~x2 & ~x3 & ~x4)  // 0000
    | (~x1 & ~x2 &  x3 & ~x4)  // 0010
    | ( x1 &  x2 & ~x3 & ~x4)  // 1100
    | ( x1 &  x2 & ~x3 &  x4)  // 1101
    | ( x1 &  x2 &  x3 &  x4)  // 1111
    | ( x1 & ~x2 & ~x3 & ~x4)  // 1000
    | ( x1 & ~x2 & ~x3 &  x4)  // 1001
    | ( x1 & ~x2 &  x3 & ~x4)  // 1010
    | ( x1 &  x2 &  x3 & ~x4); // 1110 is 0 in map, so not included

endmodule