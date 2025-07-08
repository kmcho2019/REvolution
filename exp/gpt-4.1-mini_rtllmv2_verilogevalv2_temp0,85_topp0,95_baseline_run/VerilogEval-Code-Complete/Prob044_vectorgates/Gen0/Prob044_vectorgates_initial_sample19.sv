module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  // Bitwise OR of a and b
  assign out_or_bitwise = a | b;

  // Logical OR of a and b (true if either is non-zero)
  assign out_or_logical = (a != 3'b000) || (b != 3'b000);

  // Bitwise NOT of b in bits [5:3], NOT of a in bits [2:0]
  assign out_not = {~b, ~a};

endmodule