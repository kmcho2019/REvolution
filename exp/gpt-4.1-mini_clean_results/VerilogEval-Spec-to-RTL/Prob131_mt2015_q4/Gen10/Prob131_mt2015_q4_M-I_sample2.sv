module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Using waveform hint: output z is 1 when x == y else 0 => z = ~(x ^ y)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  // Instantiate first pair of A and B
  A a1(.x(x), .y(y), .z(a1_out));
  B b1(.x(x), .y(y), .z(b1_out));

  // Instantiate second pair of A and B
  A a2(.x(x), .y(y), .z(a2_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // OR gate connected to first pair outputs
  assign or_out = a1_out | b1_out;

  // AND gate connected to second pair outputs
  assign and_out = a2_out & b2_out;

  // Final XOR gate
  assign z = or_out ^ and_out;
endmodule