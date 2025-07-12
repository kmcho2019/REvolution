module A(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
  wire a, b;
  wire or_out, and_out;

  // Single instances of A and B modules
  A A_inst(.x(x), .y(y), .z(a));
  B B_inst(.x(x), .y(y), .z(b));

  // OR and AND gates both operate on the same outputs
  assign or_out = a | b;
  assign and_out = a & b;

  // XOR of OR and AND outputs drives z
  assign z = or_out ^ and_out;
endmodule