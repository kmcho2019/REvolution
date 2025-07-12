module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Single instance of A and B modules
  A a(.x(x), .y(y), .z(a_out));
  B b(.x(x), .y(y), .z(b_out));

  // OR and AND gates using same A and B outputs
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // XOR of OR and AND outputs as final output
  assign z = or_out ^ and_out;
endmodule