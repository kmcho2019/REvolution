module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Single instances of A and B reused for both pairs
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // First pair: OR gate of A and B outputs
  assign or_out = a_out | b_out;

  // Second pair: AND gate of same A and B outputs
  assign and_out = a_out & b_out;

  // XOR of OR and AND gates produces final output
  assign z = or_out ^ and_out;
endmodule