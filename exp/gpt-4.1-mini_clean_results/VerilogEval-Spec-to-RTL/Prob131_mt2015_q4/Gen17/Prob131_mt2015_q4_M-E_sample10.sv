module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z output behavior matches waveform implying z = ~(x ^ y) (XNOR)
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

  // OR gate connected to outputs of first A and first B
  assign or_out = a1_out | b1_out;

  // AND gate connected to outputs of second A and second B
  assign and_out = a2_out & b2_out;

  // XOR gate connected to OR and AND outputs
  assign z = or_out ^ and_out;
endmodule