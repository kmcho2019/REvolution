module A(input wire x, input wire y, output wire z);
  // Implements z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Implements z = XNOR of x and y (z = ~(x ^ y))
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Single instance each of A and B modules
  // Since all submodules receive identical inputs (x,y),
  // their outputs are identical; thus we share these outputs.
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // OR and AND gates as per problem description:
  // Output of first A and B connected to OR gate,
  // output of second A and B connected to AND gate
  // Here, both pairs are identical, so reuse same outputs.
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // Final XOR gate produces output z
  assign z = or_out ^ and_out;
endmodule