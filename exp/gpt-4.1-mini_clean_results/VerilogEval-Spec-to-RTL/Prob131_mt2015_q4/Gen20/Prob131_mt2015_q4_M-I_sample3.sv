module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // B output matches waveform: z = XNOR(x, y)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out;
  wire b_out;
  wire or_out;
  wire and_out;

  // Single instance of A and B shared for both branches
  A a(.x(x), .y(y), .z(a_out));
  B b(.x(x), .y(y), .z(b_out));

  // OR gate on A and B outputs for first branch
  assign or_out = a_out | b_out;

  // AND gate on A and B outputs for second branch
  assign and_out = a_out & b_out;

  // XOR of OR and AND outputs produces final z
  assign z = or_out ^ and_out;
endmodule