module A(input wire x, input wire y, output wire z);
  // Continuous assignment for z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // Continuous assignment for z = XNOR(x, y)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;
  wire or_out, and_out;

  // Shared single instances of A and B modules
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // First OR gate: output of A and B
  assign or_out = a_out | b_out;

  // Second AND gate: same inputs as OR (shared outputs)
  assign and_out = a_out & b_out;

  // Final XOR gate combining OR and AND outputs
  assign z = or_out ^ and_out;
endmodule