module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  // Bitwise OR of the two vectors
  assign out_or_bitwise = a | b;

  // Logical OR of the two vectors (true if any bit in a or b is set)
  assign out_or_logical = (|a) | (|b);

  // Invert b and place in upper half, invert a and place in lower half
  assign out_not = { ~b, ~a };

endmodule