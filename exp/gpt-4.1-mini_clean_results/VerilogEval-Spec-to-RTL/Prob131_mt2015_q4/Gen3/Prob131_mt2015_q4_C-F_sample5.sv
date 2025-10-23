module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y based on given waveform
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_result, and_result;

  // Instantiate single A and B modules to avoid duplicate logic
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // Use the same outputs for both pairs as per problem logic
  // First pair combined with OR
  assign or_result = a_out | b_out;

  // Second pair combined with AND
  assign and_result = a_out & b_out;

  // Final output is XOR of OR and AND results
  assign z = or_result ^ and_result;
endmodule