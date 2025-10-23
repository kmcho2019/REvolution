// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
  assign z = (x ^ y) & x;
endmodule

// Module B: output waveform shows z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
  assign z = ~(x ^ y);
endmodule

// Top-level module instantiates one A and one B.
// Outputs from A and B are logically replicated to model two pairs of submodules.
// The first pair's outputs feed an OR gate,
// the second pair's outputs feed an AND gate,
// then the OR and AND outputs are XOR'ed to produce z.
module TopModule(input wire x, input wire y, output wire z);
  // Outputs from single instances of A and B
  wire a_out, b_out;

  // Logical replication of outputs to represent the two submodules each
  wire a_out_1 = a_out;
  wire a_out_2 = a_out;
  wire b_out_1 = b_out;
  wire b_out_2 = b_out;

  // OR gate for the first pair (A1 OR B1)
  wire or_out = a_out_1 | b_out_1;
  // AND gate for the second pair (A2 AND B2)
  wire and_out = a_out_2 & b_out_2;
  // XOR final output
  assign z = or_out ^ and_out;

  // Instantiate modules A and B once each
  A A_inst(.x(x), .y(y), .z(a_out));
  B B_inst(.x(x), .y(y), .z(b_out));
endmodule