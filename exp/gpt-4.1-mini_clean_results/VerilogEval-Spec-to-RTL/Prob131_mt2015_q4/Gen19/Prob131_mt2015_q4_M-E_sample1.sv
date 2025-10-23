module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Implementing logic that matches given waveform for B: z is XNOR(x, y)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;

  // Instantiate first pair: A1 and B1
  A a1(.x(x), .y(y), .z(a1_out));
  B b1(.x(x), .y(y), .z(b1_out));

  // Instantiate second pair: A2 and B2
  A a2(.x(x), .y(y), .z(a2_out));
  B b2(.x(x), .y(y), .z(b2_out));

  // OR gate on first pair outputs
  assign or_out = a1_out | b1_out;

  // AND gate on second pair outputs
  assign and_out = a2_out & b2_out;

  // XOR of or_out and and_out produces final output z
  assign z = or_out ^ and_out;
endmodule