module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y: 1 if x == y, else 0
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  // Instantiate two A modules
  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));

  // Instantiate two B modules
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // OR gate for outputs of first A and B modules
  assign or_out = a1_out | b1_out;

  // AND gate for outputs of second A and B modules
  assign and_out = a2_out & b2_out;

  // Final XOR gate produces output z
  assign z = or_out ^ and_out;
endmodule