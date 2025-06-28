module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  // Bitwise OR operation
  assign out_or_bitwise = a | b;

  // Logical OR operation
  assign out_or_logical = (a != 3'b0) || (b != 3'b0);

  // Inverse (NOT) operation
  assign out_not = {~b, ~a};

endmodule