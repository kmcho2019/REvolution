module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a_common, b_common;
  wire or_out, and_out;

  // Instantiate one A and one B module
  A a_inst(.x(x), .y(y), .z(a_common));
  B b_inst(.x(x), .y(y), .z(b_common));

  // Use the common outputs to simulate two instances each
  // First A and B outputs (a1_out and b1_out) = a_common, b_common
  // Second A and B outputs (a2_out and b2_out) = a_common, b_common

  // OR gate connected to first pair outputs
  assign or_out = a_common | b_common;

  // AND gate connected to second pair outputs
  assign and_out = a_common & b_common;

  // Final XOR gate
  assign z = or_out ^ and_out;
endmodule