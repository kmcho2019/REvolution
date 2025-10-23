module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = 1 when x == y, else 0 (XNOR)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out;
  wire b_out;
  wire or_out, and_out;

  // Single instance of A and B modules shared
  A a1(.x(x), .y(y), .z(a_out));
  B b1(.x(x), .y(y), .z(b_out));

  // OR and AND gates use shared outputs
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // XOR of OR and AND results produces final output
  assign z = or_out ^ and_out;
endmodule