module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1, a2;
  wire b1, b2;
  wire or_out, and_out;

  // First pair of submodules
  A A1(.x(x), .y(y), .z(a1));
  B B1(.x(x), .y(y), .z(b1));

  // Second pair of submodules
  A A2(.x(x), .y(y), .z(a2));
  B B2(.x(x), .y(y), .z(b2));

  // OR gate of first pair outputs
  assign or_out = a1 | b1;

  // AND gate of second pair outputs
  assign and_out = a2 & b2;

  // XOR gate of OR and AND outputs drives final output
  assign z = or_out ^ and_out;
endmodule