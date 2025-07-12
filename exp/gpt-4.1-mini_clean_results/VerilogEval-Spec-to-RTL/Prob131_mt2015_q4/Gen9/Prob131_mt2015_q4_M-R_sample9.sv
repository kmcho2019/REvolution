module TopModule(input wire x, input wire y, output wire z);
  wire a_out;
  wire b_out;
  wire or_out, and_out;

  // Inline logic for A: z = (x ^ y) & x
  assign a_out = (x ^ y) & x;

  // Inline logic for B: z = ~(x ^ y) (XNOR)
  assign b_out = ~(x ^ y);

  // OR and AND gates combining A and B outputs
  assign or_out = a_out | b_out;
  assign and_out = a_out & b_out;

  // Final XOR produces output z
  assign z = or_out ^ and_out;
endmodule