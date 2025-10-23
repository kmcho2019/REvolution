module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = 1 when x == y, else 0; equivalent to x XNOR y
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out1, a_out2;
  wire b_out1, b_out2;
  wire or_result, and_result;

  // Instantiate first pair of A and B
  A a_inst1(.x(x), .y(y), .z(a_out1));
  B b_inst1(.x(x), .y(y), .z(b_out1));

  // Instantiate second pair of A and B
  A a_inst2(.x(x), .y(y), .z(a_out2));
  B b_inst2(.x(x), .y(y), .z(b_out2));

  // OR gate for first pair outputs
  assign or_result = a_out1 | b_out1;

  // AND gate for second pair outputs
  assign and_result = a_out2 & b_out2;

  // XOR the results to form final output
  assign z = or_result ^ and_result;
endmodule