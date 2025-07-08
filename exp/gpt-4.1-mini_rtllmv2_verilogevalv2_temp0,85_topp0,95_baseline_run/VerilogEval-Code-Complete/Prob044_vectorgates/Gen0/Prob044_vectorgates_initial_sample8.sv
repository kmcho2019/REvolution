module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  assign out_or_bitwise = a | b;              // bitwise OR of a and b
  assign out_or_logical = (a != 3'b000) || (b != 3'b000); // logical OR of vectors
  assign out_not = {~b, ~a};                   // concatenation of inverted b and a

endmodule