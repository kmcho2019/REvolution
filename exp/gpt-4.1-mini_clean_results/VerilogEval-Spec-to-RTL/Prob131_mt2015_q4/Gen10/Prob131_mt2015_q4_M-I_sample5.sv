module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = XNOR of x and y (equality)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out;
  wire b_out;
  wire or_out, and_out;

  // Single instance of A and B reused
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // OR of first pair outputs (both a_out and b_out)
  assign or_out = a_out | b_out;

  // AND of second pair outputs (using the same outputs since inputs identical)
  assign and_out = a_out & b_out;

  // Final XOR of OR and AND outputs
  assign z = or_out ^ and_out;
endmodule