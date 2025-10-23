module A(input wire x, input wire y, output wire z);
  // z = (x XOR y) AND x
  assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
  // z = ~(x XOR y) (XNOR)
  assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
  wire a1_out, b1_out;
  wire a2_out, b2_out;
  wire or_out, and_out;

  // Compute module A functionality directly with assign
  assign a1_out = (x ^ y) & x;
  assign a2_out = a1_out; // same logic since inputs same

  // Compute module B functionality directly with assign
  assign b1_out = ~(x ^ y);
  assign b2_out = b1_out; // same logic since inputs same

  // First pair OR gate
  assign or_out = a1_out | b1_out;
  // Second pair AND gate
  assign and_out = a2_out & b2_out;

  // Final XOR gate produces output z
  assign z = or_out ^ and_out;
endmodule