module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y (based on waveform)
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

  // First pair: OR gate of first A and B outputs
  assign or_out = a1_out | b1_out;

  // Second pair: AND gate of second A and B outputs
  assign and_out = a2_out & b2_out;

  // XOR of OR and AND gates produces final output
  assign z = or_out ^ and_out;
endmodule