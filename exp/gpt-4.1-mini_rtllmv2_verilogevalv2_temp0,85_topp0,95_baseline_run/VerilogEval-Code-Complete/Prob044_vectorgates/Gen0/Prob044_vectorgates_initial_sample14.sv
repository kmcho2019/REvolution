module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  // Bitwise OR of a and b
  assign out_or_bitwise = a | b;
  
  // Logical OR: 1 if either a or b is non-zero, else 0
  assign out_or_logical = (a != 0) || (b != 0);
  
  // Inverse of b in upper half, inverse of a in lower half of out_not
  assign out_not = {~b, ~a};

endmodule