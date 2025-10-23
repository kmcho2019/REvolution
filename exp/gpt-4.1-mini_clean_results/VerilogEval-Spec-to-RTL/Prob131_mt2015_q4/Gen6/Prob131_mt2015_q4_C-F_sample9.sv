module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y (based on waveform analysis)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out;
  wire b_out;
  wire or_out;
  wire and_out;

  // Single instances of A and B modules
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // First pair outputs combined with OR gate
  assign or_out = a_out | b_out;

  // Second pair outputs combined with AND gate (reusing same outputs)
  assign and_out = a_out & b_out;

  // Final output is XOR of OR and AND gates
  assign z = or_out ^ and_out;
endmodule