// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

// Module B: inferred from waveform as XNOR function
module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

// Top-level module optimized by fusing best ideas:
// - Single instances of A and B submodules to reduce area and power
// - Direct XOR of outputs a_out and b_out (from A and B) instead of OR and AND combination
// This reduces gate count and logic depth, improving performance and power efficiency.
module TopModule(input wire x, input wire y, output wire z);
  wire a_out, b_out;

  // Single instance of A and B
  A a_inst(.x(x), .y(y), .z(a_out));
  B b_inst(.x(x), .y(y), .z(b_out));

  // Direct XOR of outputs from A and B
  assign z = a_out ^ b_out;
endmodule