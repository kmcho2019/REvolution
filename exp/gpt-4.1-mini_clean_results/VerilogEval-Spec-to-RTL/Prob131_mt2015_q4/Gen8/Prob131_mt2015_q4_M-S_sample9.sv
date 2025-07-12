module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Single instances of A and B modules reused
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // OR and AND of same outputs from A and B
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // Final XOR output
  assign z = or_out ^ and_out;
endmodule