module A(input wire x, input wire y, output wire z);
  // Module A implements: z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Module B implements XNOR operation: z = x XNOR y
  assign z = x ~^ y;
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Instantiate one A and one B module with shared inputs
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // OR gate combines outputs of A and B
  assign or_out = a_out | b_out;

  // AND gate combines outputs of A and B
  assign and_out = a_out & b_out;

  // XOR gate combines OR and AND results for final output
  assign z = or_out ^ and_out;
endmodule