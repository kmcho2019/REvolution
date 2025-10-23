module A(input wire x, input wire y, output wire z);
  // Simplified: z = x & ~y
  assign z = x & ~y;
endmodule

module B(input wire x, input wire y, output wire z);
  // Simplified XNOR: z = (x & y) | (~x & ~y)
  assign z = (x & y) | (~x & ~y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Single instance each as outputs identical for both pairs
  A a(.x(x), .y(y), .z(a_out));
  B b(.x(x), .y(y), .z(b_out));

  // OR and AND gates on same outputs as per spec connection
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // XOR of OR and AND outputs as final output
  assign z = or_out ^ and_out;
endmodule