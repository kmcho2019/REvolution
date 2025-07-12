module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // From waveform, z = XNOR(x, y)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1, a2, b1, b2;
  wire or_out, and_out;

  // Instantiate two A submodules
  A A1(.x(x), .y(y), .z(a1));
  A A2(.x(x), .y(y), .z(a2));

  // Instantiate two B submodules
  B B1(.x(x), .y(y), .z(b1));
  B B2(.x(x), .y(y), .z(b2));

  // OR gate: outputs of first A and first B
  assign or_out = a1 | b1;

  // AND gate: outputs of second A and second B
  assign and_out = a2 & b2;

  // XOR gate: OR and AND outputs
  assign z = or_out ^ and_out;
endmodule