module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x implemented with continuous assignment
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y implemented with continuous assignment
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Single instances of A and B modules
  A a(.x(x), .y(y), .z(a_out));
  B b(.x(x), .y(y), .z(b_out));

  // First pair's OR: a_out OR b_out
  assign or_out = a_out | b_out;

  // Second pair's AND: a_out AND b_out
  assign and_out = a_out & b_out;

  // Final XOR of the OR and AND outputs
  assign z = or_out ^ and_out;
endmodule