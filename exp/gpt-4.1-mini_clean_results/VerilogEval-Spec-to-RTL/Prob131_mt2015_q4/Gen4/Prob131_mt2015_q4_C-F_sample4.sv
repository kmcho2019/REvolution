module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = 1 when x == y, else 0 (XNOR)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out1, a_out2;
  wire b_out1, b_out2;
  wire or_out, and_out;

  // Instantiate first pair of A and B modules
  A a1(.x(x), .y(y), .z(a_out1));
  B b1(.x(x), .y(y), .z(b_out1));

  // Instantiate second pair of A and B modules
  A a2(.x(x), .y(y), .z(a_out2));
  B b2(.x(x), .y(y), .z(b_out2));

  // OR gate on first pair outputs
  assign or_out = a_out1 | b_out1;

  // AND gate on second pair outputs
  assign and_out = a_out2 & b_out2;

  // XOR of OR and AND results produces final output
  assign z = or_out ^ and_out;
endmodule