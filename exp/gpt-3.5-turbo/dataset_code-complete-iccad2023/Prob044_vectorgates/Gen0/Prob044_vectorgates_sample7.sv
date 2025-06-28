module BitwiseOR (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or
);
  assign out_or = a | b;
endmodule

module LogicalOR (
  input [2:0] a,
  input [2:0] b,
  output out_or
);
  assign out_or = |{a, b};
endmodule

module InvertVector (
  input [2:0] in_vector,
  output [2:0] out_vector
);
  assign out_vector = ~in_vector;
endmodule

module TopModule (
  input [2:0] a,
  input [2:0] b,
  output [2:0] out_or_bitwise,
  output out_or_logical,
  output [5:0] out_not
);

  BitwiseOR bitwise_or_inst(
    .a(a),
    .b(b),
    .out_or(out_or_bitwise)
  );

  LogicalOR logical_or_inst(
    .a(a),
    .b(b),
    .out_or(out_or_logical)
  );

  InvertVector invert_b_inst(
    .in_vector(b),
    .out_vector(out_not[5:3])
  );

  InvertVector invert_a_inst(
    .in_vector(a),
    .out_vector(out_not[2:0])
  );

endmodule