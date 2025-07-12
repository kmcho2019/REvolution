module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y based on waveform analysis
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_result, and_result;

  // Instantiate one A and one B module to reduce area and power
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // Use the same a_out and b_out signals as the outputs of both pairs:
  // First pair combined with OR gate
  assign or_result = a_out | b_out;

  // Second pair combined with AND gate
  assign and_result = a_out & b_out;

  // Final output is XOR of OR and AND results
  assign z = or_result ^ and_result;
endmodule