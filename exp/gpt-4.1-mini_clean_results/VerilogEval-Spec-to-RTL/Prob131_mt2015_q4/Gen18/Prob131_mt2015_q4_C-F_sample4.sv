// Module A: z = (x XOR y) AND x
module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

// Module B: waveform matches z = ~(x ^ y) (XNOR)
module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

// Combined AB module that instantiates A and B internally to share input signals,
// keeping A and B modularity but sharing inputs in one wrapper.
module AB(input wire x, input wire y, output wire a_out, output wire b_out);
  wire a_internal, b_internal;

  A a_inst(.x(x), .y(y), .z(a_internal));
  B b_inst(.x(x), .y(y), .z(b_internal));

  assign a_out = a_internal;
  assign b_out = b_internal;
endmodule

// Top module: instantiates two AB modules as pairs of A and B,
// connects first pair outputs to OR gate, second pair outputs to AND gate,
// final output is XOR of these two results.
module TopModule(input wire x, input wire y, output wire z);
  wire a1, b1, a2, b2;
  wire or_out, and_out;

  // First AB pair
  AB ab1(.x(x), .y(y), .a_out(a1), .b_out(b1));
  assign or_out = a1 | b1;

  // Second AB pair
  AB ab2(.x(x), .y(y), .a_out(a2), .b_out(b2));
  assign and_out = a2 & b2;

  // Final XOR output
  assign z = or_out ^ and_out;
endmodule