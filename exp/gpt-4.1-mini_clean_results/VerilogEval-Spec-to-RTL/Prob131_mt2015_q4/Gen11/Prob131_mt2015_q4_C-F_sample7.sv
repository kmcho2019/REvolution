module A(input wire x, input wire y, output wire z);
  // Implements the boolean function: z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Implements the boolean function: z = XNOR(x, y) = ~(x XOR y)
  // Matches the observed waveform behavior.
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  // Instantiate two copies of module A and two of module B
  // Each receives identical inputs 'x' and 'y' as specified.
  // Outputs of the first pair (A1, B1) feed into an OR gate.
  // Outputs of the second pair (A2, B2) feed into an AND gate.
  // Final output z is XOR of OR and AND results.
  
  wire a1_out, a2_out;
  wire b1_out, b2_out;
  wire or_out, and_out;
  
  A a1(.x(x), .y(y), .z(a1_out));
  A a2(.x(x), .y(y), .z(a2_out));
  
  B b1(.x(x), .y(y), .z(b1_out));
  B b2(.x(x), .y(y), .z(b2_out));
  
  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;
endmodule