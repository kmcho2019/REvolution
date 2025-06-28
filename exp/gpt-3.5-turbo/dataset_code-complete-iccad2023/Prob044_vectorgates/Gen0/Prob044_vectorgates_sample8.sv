module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  assign out_or_bitwise = a | b;
  assign out_or_logical = (a != 3'b0) || (b != 3'b0); // logical OR is true if either a or b is not all zeros
  
  // Invert (NOT) vectors a and b separately
  assign {out_not[5:3], out_not[2:0]} = {~b, ~a}; // b inverted bits in upper half [5:3], a inverted bits in lower half [2:0]

endmodule