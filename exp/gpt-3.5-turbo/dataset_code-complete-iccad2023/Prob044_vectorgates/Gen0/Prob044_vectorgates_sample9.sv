module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  assign out_or_bitwise = a | b; // Bitwise OR operation
  
  assign out_or_logical = (a || b); // Logical OR operation
  
  assign out_not[2:0] = ~b; // NOT of b, placed in bits [5:3]
  assign out_not[5:3] = ~a; // NOT of a, placed in bits [2:0]

endmodule