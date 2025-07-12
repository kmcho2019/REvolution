module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out1, b_out1;
  wire a_out2, b_out2;
  wire or_out, and_out;

  // Instantiate two A modules
  A a1(.x(x), .y(y), .z(a_out1));
  A a2(.x(x), .y(y), .z(a_out2));

  // Instantiate two B modules
  B b1(.x(x), .y(y), .z(b_out1));
  B b2(.x(x), .y(y), .z(b_out2));

  // OR gate: output of first A and first B
  assign or_out = a_out1 | b_out1;

  // AND gate: output of second A and second B
  assign and_out = a_out2 & b_out2;

  // XOR gate: XOR of OR and AND outputs
  assign z = or_out ^ and_out;
endmodule