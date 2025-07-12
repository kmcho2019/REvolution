module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y (optimized with ~^)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  // Instantiate two A modules with identical inputs
  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));

  // Instantiate two B modules with identical inputs
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // Since both A outputs are identical, OR reduces to one output
  // Similarly, since both B outputs are identical, OR reduces to one output
  // But per problem, first pair outputs go to OR gate
  assign or_out = a1_out | b1_out;

  // Second pair outputs go to AND gate directly
  assign and_out = a2_out & b2_out;

  // Final output is XOR of OR and AND results
  assign z = or_out ^ and_out;
endmodule